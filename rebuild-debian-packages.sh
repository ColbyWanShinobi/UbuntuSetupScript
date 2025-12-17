#!/bin/bash
#
# Debian Package Rebuild Script
# Rebuilds Debian packages with custom patches
# Packages are discovered from subdirectories in the patches/ folder
#
# Usage: ./rebuild-debian-packages.sh [options]
#   Options:
#     --package <name>    Build only specific package
#     --debian-release    Debian release to build for (default: trixie)
#     --skip-deps         Skip dependency installation
#     --clean             Clean build directories before starting
#     --help              Show this help message
#

set -euo pipefail

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCHES_DIR="${SCRIPT_DIR}/patches"
BUILD_DIR="${SCRIPT_DIR}/debian-build"
DEBIAN_RELEASE="${DEBIAN_RELEASE:-trixie}"
SKIP_DEPS=false
CLEAN_BUILD=false
BUILD_PACKAGE=""

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*" >&2
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Discover available packages from patches directory
discover_packages() {
    local -a packages=()

    if [[ ! -d "$PATCHES_DIR" ]]; then
        log_error "Patches directory not found: $PATCHES_DIR"
        exit 1
    fi

    # Find all directories in patches/
    while IFS= read -r -d '' dir; do
        local pkg_name
        pkg_name=$(basename "$dir")
        packages+=("$pkg_name")
    done < <(find "$PATCHES_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)

    if [[ ${#packages[@]} -eq 0 ]]; then
        log_error "No package directories found in $PATCHES_DIR"
        exit 1
    fi

    printf '%s\n' "${packages[@]}"
}

# Help message
show_help() {
    local -a available_packages
    mapfile -t available_packages < <(discover_packages 2>/dev/null || echo "none")

    cat << EOF
Debian Package Rebuild Script

This script downloads Debian source packages, applies custom patches from the
patches/ directory, and builds Debian packages.

Available packages (discovered from patches/ directory):
    ${available_packages[*]}

Usage: $0 [options]

Options:
    --package <name>       Build only specific package
    --debian-release <rel> Debian release to build for (default: trixie)
    --skip-deps            Skip build dependency installation
    --clean                Clean build directories before starting
    --help                 Show this help message

Examples:
    # Build all packages for Debian trixie
    $0

    # Build only a specific package
    $0 --package ${available_packages[0]:-package-name}

    # Build for Debian sid (unstable)
    $0 --debian-release sid

    # Clean build from scratch
    $0 --clean

EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --package)
                BUILD_PACKAGE="$2"
                # Validate package exists in patches directory
                if [[ ! -d "${PATCHES_DIR}/${BUILD_PACKAGE}" ]]; then
                    log_error "Invalid package: $BUILD_PACKAGE"
                    log_error "No patches directory found at: ${PATCHES_DIR}/${BUILD_PACKAGE}"
                    log_error "Valid packages:"
                    mapfile -t available_packages < <(discover_packages)
                    for pkg in "${available_packages[@]}"; do
                        log_error "  - $pkg"
                    done
                    exit 1
                fi
                shift 2
                ;;
            --debian-release)
                DEBIAN_RELEASE="$2"
                shift 2
                ;;
            --skip-deps)
                SKIP_DEPS=true
                shift
                ;;
            --clean)
                CLEAN_BUILD=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Check if running on Debian/Ubuntu
check_system() {
    log_info "Checking system compatibility..."

    if [[ ! -f /etc/debian_version ]]; then
        log_error "This script must be run on a Debian or Ubuntu system"
        exit 1
    fi

    local debian_version
    debian_version=$(cat /etc/debian_version)
    log_success "Running on Debian/Ubuntu (version: $debian_version)"
}

# Install build dependencies
install_dependencies() {
    if [[ "$SKIP_DEPS" == true ]]; then
        log_warn "Skipping dependency installation (--skip-deps)"
        return
    fi

    log_info "Installing build dependencies..."

    local packages=(
        build-essential
        devscripts
        debhelper
        dh-make
        quilt
        fakeroot
        lintian
        dpkg-dev
        wget
        git
    )

    # Check if running as root or with sudo
    if [[ $EUID -eq 0 ]]; then
        apt-get update
        apt-get install -y "${packages[@]}"
    else
        log_info "Need sudo to install packages..."
        sudo apt-get update
        sudo apt-get install -y "${packages[@]}"
    fi

    log_success "Build dependencies installed"
}

# Clean build directories
clean_build_dir() {
    if [[ "$CLEAN_BUILD" == true ]] && [[ -d "$BUILD_DIR" ]]; then
        log_info "Cleaning build directory: $BUILD_DIR"
        rm -rf "$BUILD_DIR"
        log_success "Build directory cleaned"
    fi
}

# Create build directory structure
setup_build_dir() {
    log_info "Setting up build directory: $BUILD_DIR"
    mkdir -p "$BUILD_DIR"

    # Create directories for each discovered package
    local -a packages
    mapfile -t packages < <(discover_packages)
    for pkg in "${packages[@]}"; do
        mkdir -p "$BUILD_DIR/$pkg"
    done

    log_success "Build directory created"
}

# Download Debian source package
download_source() {
    local pkg_name=$1
    local pkg_dir="${BUILD_DIR}/${pkg_name}"

    log_info "Downloading Debian source package: $pkg_name"

    cd "$pkg_dir"

    # Enable source repositories if not already enabled
    if ! grep -q "^deb-src" /etc/apt/sources.list /etc/apt/sources.list.d/* 2>/dev/null; then
        log_warn "Source repositories not enabled. You may need to enable them manually."
        log_warn "Add 'deb-src' lines to /etc/apt/sources.list"
    fi

    # Update package lists
    if [[ $EUID -eq 0 ]]; then
        apt-get update >/dev/null 2>&1 || true
    else
        sudo apt-get update >/dev/null 2>&1 || true
    fi

    # Download source package
    if ! apt source "$pkg_name" >&2; then
        log_error "Failed to download source package: $pkg_name"
        log_error "Make sure deb-src repositories are enabled in /etc/apt/sources.list"
        return 1
    fi

    log_success "Source package downloaded: $pkg_name"

    # Find the extracted source directory
    local source_dir
    source_dir=$(find . -maxdepth 1 -type d -name "${pkg_name}-*" | head -1)

    if [[ -z "$source_dir" ]]; then
        log_error "Could not find extracted source directory"
        return 1
    fi

    echo "$source_dir"
}

# Install build dependencies for package
install_build_deps() {
    local pkg_name=$1
    local source_dir=$2

    if [[ "$SKIP_DEPS" == true ]]; then
        log_warn "Skipping build-dep installation (--skip-deps)"
        return
    fi

    log_info "Installing build dependencies for $pkg_name..."

    cd "$source_dir"

    if [[ $EUID -eq 0 ]]; then
        apt-get build-dep -y .
    else
        sudo apt-get build-dep -y .
    fi

    log_success "Build dependencies installed for $pkg_name"
}

# Apply patches
apply_patches() {
    local pkg_name=$1
    local source_dir=$2
    local patch_dir="${PATCHES_DIR}/${pkg_name}"

    log_info "Applying patches to $pkg_name..."

    if [[ ! -d "$patch_dir" ]]; then
        log_error "Patch directory not found: $patch_dir"
        return 1
    fi

    cd "$source_dir"

    # Create debian/patches directory if it doesn't exist
    mkdir -p debian/patches

    # Find all .patch files
    local patches
    mapfile -t patches < <(find "$patch_dir" -name "*.patch" | sort)

    if [[ ${#patches[@]} -eq 0 ]]; then
        log_warn "No patches found in $patch_dir"
        return 0
    fi

    log_info "Found ${#patches[@]} patch(es) to apply"

    # Copy patches to debian/patches
    local patch_num=1000
    local series_file="debian/patches/series"

    # Backup existing series file if it exists
    if [[ -f "$series_file" ]]; then
        cp "$series_file" "${series_file}.backup"
        log_info "Backed up existing series file"
    fi

    # Create/append to series file
    for patch in "${patches[@]}"; do
        local patch_basename
        patch_basename=$(basename "$patch")
        local new_patch_name="${patch_num}-${patch_basename}"

        # Copy patch
        cp "$patch" "debian/patches/${new_patch_name}"

        # Add to series file
        echo "${new_patch_name}" >> "$series_file"

        log_info "  Added patch: ${new_patch_name}"
        ((patch_num++))
    done

    log_success "Applied ${#patches[@]} patch(es)"

    # Try to apply patches to verify they work
    log_info "Verifying patches apply cleanly..."
    export QUILT_PATCHES=debian/patches

    if command -v quilt &> /dev/null; then
        if quilt push -a; then
            log_success "All patches applied successfully"
            quilt pop -a  # Unapply for clean build
        else
            log_error "Some patches failed to apply!"
            log_error "You may need to refresh the patches manually"
            quilt pop -a 2>/dev/null || true
            return 1
        fi
    else
        log_warn "quilt not available, skipping patch verification"
    fi
}

# Update debian/changelog with custom version
update_changelog() {
    local pkg_name=$1
    local source_dir=$2

    log_info "Updating debian/changelog..."

    cd "$source_dir"

    if [[ ! -f debian/changelog ]]; then
        log_error "debian/changelog not found"
        return 1
    fi

    # Get current version
    local current_version
    current_version=$(dpkg-parsechangelog -S Version)

    # Create new version with custom suffix
    local new_version="${current_version}custom1"

    # Create new changelog entry
    DEBEMAIL="user@localhost" DEBFULLNAME="Custom Build" \
        dch --newversion "$new_version" --distribution "$DEBIAN_RELEASE" \
        "Custom rebuild with patches"

    log_success "Updated version to: $new_version"
}

# Build the package
build_package() {
    local pkg_name=$1
    local source_dir=$2

    log_info "Building Debian package: $pkg_name"

    cd "$source_dir"

    # Build package (unsigned for local use)
    log_info "Running dpkg-buildpackage..."

    if dpkg-buildpackage -us -uc -b 2>&1 | tee "../build-${pkg_name}.log"; then
        log_success "Package built successfully: $pkg_name"
    else
        log_error "Package build failed: $pkg_name"
        log_error "Check the build log: ${BUILD_DIR}/${pkg_name}/build-${pkg_name}.log"
        return 1
    fi

    # List built packages
    log_info "Built packages:"
    find "$BUILD_DIR/$pkg_name" -maxdepth 1 -name "*.deb" -type f -exec basename {} \; | while read -r deb; do
        log_success "  - $deb"
    done
}

# Process a single package
process_package() {
    local pkg_name=$1

    log_info "========================================"
    log_info "Processing package: $pkg_name"
    log_info "========================================"

    # Download source
    local source_dir
    source_dir=$(download_source "$pkg_name")

    if [[ -z "$source_dir" ]] || [[ ! -d "${BUILD_DIR}/${pkg_name}/${source_dir}" ]]; then
        log_error "Failed to download source for $pkg_name"
        return 1
    fi

    local full_source_dir="${BUILD_DIR}/${pkg_name}/${source_dir}"

    # Install build dependencies
    install_build_deps "$pkg_name" "$full_source_dir"

    # Apply patches
    if ! apply_patches "$pkg_name" "$full_source_dir"; then
        log_error "Failed to apply patches for $pkg_name"
        return 1
    fi

    # Update changelog
    update_changelog "$pkg_name" "$full_source_dir"

    # Build package
    if ! build_package "$pkg_name" "$full_source_dir"; then
        log_error "Failed to build package: $pkg_name"
        return 1
    fi

    log_success "Package completed: $pkg_name"
    echo ""
}

# Main function
main() {
    echo ""
    log_info "========================================"
    log_info "Debian Package Rebuild Script"
    log_info "========================================"
    echo ""

    parse_args "$@"

    # Discover available packages
    local -a available_packages
    mapfile -t available_packages < <(discover_packages)

    log_info "Configuration:"
    log_info "  Debian Release: $DEBIAN_RELEASE"
    log_info "  Build Directory: $BUILD_DIR"
    log_info "  Patch Directory: ${PATCHES_DIR}"
    log_info "  Available Packages: ${available_packages[*]}"
    if [[ -n "$BUILD_PACKAGE" ]]; then
        log_info "  Building: $BUILD_PACKAGE only"
    else
        log_info "  Building: all packages"
    fi
    echo ""

    # System checks
    check_system

    # Install dependencies
    install_dependencies

    # Clean if requested
    clean_build_dir

    # Setup build directory
    setup_build_dir

    # Build packages
    local failed_packages=()

    if [[ -n "$BUILD_PACKAGE" ]]; then
        # Build single package
        if ! process_package "$BUILD_PACKAGE"; then
            failed_packages+=("$BUILD_PACKAGE")
        fi
    else
        # Build all packages
        for pkg_name in "${available_packages[@]}"; do
            if ! process_package "$pkg_name"; then
                failed_packages+=("$pkg_name")
            fi
        done
    fi

    # Summary
    echo ""
    log_info "========================================"
    log_info "Build Summary"
    log_info "========================================"
    echo ""

    if [[ ${#failed_packages[@]} -eq 0 ]]; then
        log_success "All packages built successfully!"
        echo ""
        log_info "Built packages are located in: $BUILD_DIR"
        log_info ""
        log_info "To install the packages:"
        log_info "  cd $BUILD_DIR"

        # Build the dpkg -i command with all package directories
        local install_cmd="  sudo dpkg -i"
        for pkg in "${available_packages[@]}"; do
            install_cmd+=" ${pkg}/*.deb"
        done
        log_info "$install_cmd"
        log_info "  sudo apt-get install -f  # Fix any dependency issues"
        echo ""
    else
        log_error "Some packages failed to build:"
        for pkg in "${failed_packages[@]}"; do
            log_error "  - $pkg"
        done
        echo ""
        exit 1
    fi
}

# Run main function
main "$@"
