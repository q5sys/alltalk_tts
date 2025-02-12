#!/bin/bash

# ANSI color codes
RED='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Navigate to the script's directory
cd "$(dirname "$0")"

# Function to check if curl is installed
check_curl() {
    if ! command -v curl &> /dev/null; then
        echo "curl is not available on this system. Please install curl then re-run the script https://curl.se/"
        echo "or perform a manual installation of a Conda Python environment."
        exit 1
    fi
}

# Main Menu
main_menu() {
    while true; do
        clear
        echo
        echo "Welcome to the AllTalk Setup Utility"
        echo
        echo "Please select an option:"
        echo
        echo "    1) I am using AllTalk as part of Text-generation-webui"
        echo "    2) I am using AllTalk as a Standalone Application"
        echo
        echo "    9) Exit/Quit"
        echo
        read -p "Enter your choice: " user_option

        case $user_option in
            1) webui_menu ;;
            2) standalone_menu ;;
            9) exit 0 ;;
            *) echo "Invalid option"; sleep 2 ;;
        esac
    done
}

# Text-generation-webui Menu
webui_menu() {
    while true; do
        clear
        echo
        echo "You have selected Text-generation-webui."
        echo
        echo -e "Please ensure you have started your Text-generation-webui Python environment."
        echo -e "If you have NOT done this, please run ${GREEN}/cmd_linux.sh${NC} in the ${GREEN}text-generation-webui${NC} folder and then re-run this script."
        echo
        echo "    1) Install the requirements for a Nvidia machine."
        echo "    2) Install the requirements for an AMD or MAC machine."
        echo "    3) Install the Finetuning requirements."
        echo "    4) Install DeepSpeed."
        echo "    5) Uninstall DeepSpeed."
        echo "    6) Generate a diagnostics file."
        echo
        echo "    9) Back to Main Menu"
        echo
        read -p "Enter your choice: " webui_option

        case $webui_option in
            1) install_nvidia_textgen ;;
            2) install_other_textgen ;;
            3) install_finetune_textgen ;;
            4) install_deepspeed ;;
            5) uninstall_deepspeed ;;
            6) generate_diagnostics_textgen ;;
            9) break ;;
            *) echo "Invalid option"; sleep 2 ;;
        esac
    done
}

install_nvidia_textgen() {
    local requirements_file="requirements_nvidia.txt"
    echo "Installing Finetune requirements from $requirements_file..."
    if ! pip install -r "$requirements_file"; then
        echo "There was an error installing the Nvidia requirements."
        echo "Please check the output for details."
        read -p "Press any key to return to the menu. " -n 1
        echo
        return
    fi
    echo "Nvidia requirements installed successfully."
    read -p "Press any key to continue. " -n 1
    echo
}

install_other_textgen() {
    local requirements_file="requirements_other.txt"
    echo "Installing Other machine requirements from $requirements_file..."
    if ! pip install -r "$requirements_file"; then
        echo "There was an error installing the Other requirements."
        echo "Please check the output for details."
        read -p "Press any key to return to the menu. " -n 1
        echo
        return
    fi
    echo "Other machine requirements installed successfully."
    read -p "Press any key to continue. " -n 1
    echo
}

install_finetune_textgen() {
    local requirements_file="requirements_finetune.txt"
    echo "Installing Finetune requirements from $requirements_file..."
    if ! pip install -r "$requirements_file"; then
        echo "There was an error installing the Finetune requirements."
        echo "Please check the output for details."
        read -p "Press any key to return to the menu. " -n 1
        echo
        return
    fi
    echo "Finetune requirements installed successfully."
    read -p "Press any key to continue. " -n 1
    echo
}

# Function to install DeepSpeed
install_deepspeed() {
    clear
    echo -e "${YELLOW}DeepSpeed Installation Prerequisites:${NC}"
    echo
    echo -e "     1. NVIDIA CUDA Toolkit must be installed from ${GREEN}https://developer.nvidia.com/cuda-toolkit-archive${NC} or your ${GREEN}Linux package manager${NC}."
    echo -e "     2. ${GREEN}libaio-dev${NC} must be installed."
    echo -e "     3. The environment variable ${GREEN}CUDA_HOME${NC} must be set (e.g. export CUDA_HOME=/usr/local/cuda)."

    echo -e "\n${RED}Please confirm that you have completed these steps before continuing with the DeepSpeed installation.${NC}"
    echo
    read -p "Have you completed all the above steps? (y/n): " confirm

    if [ "$confirm" != "y" ]; then
        echo -e "${RED}DeepSpeed installation cannot proceed without completing the prerequisites.${NC}"
        return
    fi

    echo -e "\n${GREEN}Proceeding with DeepSpeed installation...${NC}"
    pip install deepspeed
    if [ $? -ne 0 ]; then
        echo -e "${RED}There was an error installing DeepSpeed.${NC}"
        return
    fi

    echo -e "${GREEN}DeepSpeed installed successfully.${NC}"
    read -p "Press any key to continue. " -n 1
    echo
}

uninstall_deepspeed() {
    echo "Uninstalling DeepSpeed..."
    pip uninstall -y deepspeed
    if [ $? -ne 0 ]; then
        echo "There was an error uninstalling DeepSpeed."
        echo "Press any key to return to the menu."
        read -n 1
        return
    fi
    echo "DeepSpeed uninstalled successfully."
    echo "Press any key to continue."
    read -n 1
}

generate_diagnostics_textgen() {
    # Run diagnostics
    if ! python diagnostics.py; then
        echo "There was an error running diagnostics."
        read -p "Press any key to return to the menu. " -n 1
        echo
        return
    fi

    echo "Diagnostics completed successfully."
    read -p "Press any key to continue. " -n 1
    echo
}

# Standalone Menu
standalone_menu() {
    while true; do
        clear
        echo
        echo "You have selected Standalone Application Setup."
        echo
        echo "    1) Install AllTalk's custom Python environment (Setup AllTalk as a standalone Application)"
        echo "    2) Delete AllTalk's custom Python environment"
        echo "    3) Install the Finetuning requirements"
        echo "    4) Install DeepSpeed."
        echo "    5) Generate a diagnostics file"
        echo
        echo "    9) Back to Main Menu"
        echo
        read -p "Enter your choice: " standalone_option

        case $standalone_option in
            1) install_custom_standalone ;;
            2) delete_custom_standalone ;;
            3) install_finetune_standalone ;;
            4) install_deepspeed ;;
            5) generate_diagnostics_standalone ;;
            9) break ;;
            *) echo "Invalid option"; sleep 2 ;;
        esac
    done
}

install_custom_standalone() {
    cd "$(dirname "${BASH_SOURCE[0]}")"

    if [[ "$(pwd)" =~ " " ]]; then
        echo "This script relies on Miniconda which can not be silently installed under a path with spaces."
        exit
    fi

    # Deactivate existing conda envs as needed to avoid conflicts
    { conda deactivate && conda deactivate && conda deactivate; } 2> /dev/null

    OS_ARCH=$(uname -m)
    case "${OS_ARCH}" in
        x86_64*)    OS_ARCH="x86_64" ;;
        arm64* | aarch64*) OS_ARCH="aarch64" ;;
        *)          echo "Unknown system architecture: $OS_ARCH! This script runs only on x86_64 or arm64" && exit ;;
    esac

    # Config
    INSTALL_DIR="$(pwd)/alltalk_environment"
    CONDA_ROOT_PREFIX="${INSTALL_DIR}/conda"
    INSTALL_ENV_DIR="${INSTALL_DIR}/env"
    MINICONDA_DOWNLOAD_URL="https://repo.anaconda.com/miniconda/Miniconda3-py310_23.3.1-0-Linux-${OS_ARCH}.sh"

    if [ ! -x "${CONDA_ROOT_PREFIX}/bin/conda" ]; then
        echo "Downloading Miniconda from $MINICONDA_DOWNLOAD_URL to ${INSTALL_DIR}/miniconda_installer.sh"
        mkdir -p "${INSTALL_DIR}"
        curl -L "${MINICONDA_DOWNLOAD_URL}" -o "${INSTALL_DIR}/miniconda_installer.sh"
        chmod +x "${INSTALL_DIR}/miniconda_installer.sh"
        bash "${INSTALL_DIR}/miniconda_installer.sh" -b -p "${CONDA_ROOT_PREFIX}"
        echo "Miniconda installed."
    fi

    if [ ! -d "${INSTALL_ENV_DIR}" ]; then
        "${CONDA_ROOT_PREFIX}/bin/conda" create -y --prefix "${INSTALL_ENV_DIR}" python=3.11
        echo "Conda environment created at ${INSTALL_ENV_DIR}."
    fi

    # Activate the environment and install requirements
    source "${CONDA_ROOT_PREFIX}/etc/profile.d/conda.sh"
    conda activate "${INSTALL_ENV_DIR}"

    echo
    echo "Choose the type of requirements to install:"
    echo
    echo "     1. Nvidia graphics card machines"
    echo "     2. Other machines (mac, amd, etc)"
    echo
    read -p "Enter your choice (1 or 2): " user_choice

    if [ "$user_choice" == "1" ]; then
    	pip install torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 --upgrade --force-reinstall --index-url https://download.pytorch.org/whl/cu121
    	pip install numpy==1.24.4
	pip install typing-extensions>=4.8.0
	pip install networkx<3.0.0,>=2.5.0
    	pip install fsspec>=2023.6.0
	pip install soundfile==0.12.1
    	pip install uvicorn==0.24.0.post1
    	pip install TTS==0.21.3
    	pip install fastapi==0.104.1
    	pip install Jinja2==3.1.2
    	pip install requests==2.31.0
    	pip install tqdm==4.66.1
    	pip install importlib-metadata==4.8.1
    	pip install packaging==23.2
    	pip install pydantic==1.10.13
    	pip install sounddevice==0.4.6
    	pip install python-multipart==0.0.6
    else
        pip install -r requirements_other.txt
    fi

    # Create start_alltalk.sh to run AllTalk
    cat << EOF > start_alltalk.sh
#!/bin/bash
source "${CONDA_ROOT_PREFIX}/etc/profile.d/conda.sh"
conda activate "${INSTALL_ENV_DIR}"
python script.py
EOF
    chmod +x start_alltalk.sh
    echo
    echo
    echo "start_alltalk.sh has been created."
    echo -e "You can now start AllTalk with ${YELLOW}./start_alltalk.sh${NC}"
    echo
    read -p "Press any key to continue. " -n 1
}


delete_custom_standalone() {
    local env_dir="$PWD/alltalk_environment"
    # Check if the alltalk_environment directory exists
    if [ ! -d "$env_dir" ]; then
        echo "\"$env_dir\" directory does not exist. No need to delete."
        read -p "Press any key to continue. " -n 1
        echo
        return
    fi
    # Check if a Conda environment is active and deactivate it
    if [ -n "$CONDA_PREFIX" ]; then
        echo "Exiting the Conda environment. You may need to start ./atstart.sh again"
        conda deactivate
    fi
    echo "Deleting \"$env_dir\". Please wait."
    rm -rf "$env_dir"
    if [ -d "$env_dir" ]; then
        echo "Failed to delete \"$env_dir\" folder."
        echo "Please make sure it is not in use and try again."
    else
        echo "Environment \"$env_dir\" deleted successfully."
    fi
    read -p "Press any key to continue. " -n 1
    echo
}

install_finetune_standalone() {
    local env_dir="$PWD/alltalk_environment"
    local conda_root_prefix="${env_dir}/conda"
    local install_env_dir="${env_dir}/env"
    if [ ! -d "${install_env_dir}" ]; then
        echo "The Conda environment at '${install_env_dir}' does not exist."
        echo "Please install the environment before proceeding."
        read -p "Press any key to return to the menu. " -n 1
        echo
        return
    fi
    source "${conda_root_prefix}/etc/profile.d/conda.sh"
    conda activate "${install_env_dir}"
    local requirements_file="requirements_finetune.txt"
    echo "Installing Finetune requirements from $requirements_file..."
    if ! pip install -r "$requirements_file"; then
        echo "There was an error installing the Finetune requirements."
        echo "Please check the output for details."
        read -p "Press any key to return to the menu. " -n 1
        echo
        return
    fi
    echo "Finetune requirements installed successfully."
    read -p "Press any key to continue. " -n 1
    echo
}


generate_diagnostics_standalone() {
    local env_dir="$PWD/alltalk_environment"
    local conda_root_prefix="${env_dir}/conda"
    local install_env_dir="${env_dir}/env"
    if [ ! -d "${install_env_dir}" ]; then
        echo "The Conda environment at '${install_env_dir}' does not exist."
        echo "Please install the environment before proceeding."
        read -p "Press any key to return to the menu. " -n 1
        echo
        return
    fi
    source "${conda_root_prefix}/etc/profile.d/conda.sh"
    conda activate "${install_env_dir}"
    if ! python diagnostics.py; then
        echo "There was an error running diagnostics."
        read -p "Press any key to return to the menu. " -n 1
        echo
        return
    fi
    echo "Diagnostics completed successfully."
    read -p "Press any key to continue. " -n 1
    echo
}


# Start the main menu
main_menu
