# You can follow this page to run the container!
# https://docs.google.com/document/d/1-QxKYc98Jts67yGqR-jXCZbBvZQqMF1vyr2s0lpI-Nc/edit?usp=sharing
########### Set up nvidia container runtime
#curl https://get.docker.com | sh && sudo systemctl --now enable docker
  
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
      && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
      && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
            sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
            sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
            
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit

# Set persistence mode
#sudo -i
#nvidia-smi -pm 1
#exit

# Reboot docker
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

############ Set up files

sudo docker pull elvisyu/multiperson_image:latest

mkdir data
tar -xvf multiperson_data.tar --directory data
cp -r neutral_smpl_mean_params.h5 data
mkdir data/smpl
cp -r SMPL_NEUTRAL.pkl data/smpl
