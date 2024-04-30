
# BreastWise API

BreastWise API is a Django application for the detection of Breast Cancer in MRI scans. It uses two VGG19 models with different input channel types to detect cancer on a scan slice-by-slice basis. 
    
## Run Locally

Install Docker. 

Run this command to run the API in Docker. 

Due to the use of machine learning models, a GPU is recommended. If you use a GPU, ensure that you have NVIDIA toolkit installed on your machine. If you do not want to use a GPU, simply skip this step.

```bash
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
```

Pull the Docker image for this code. Please note that this might take some time, depending on your internet connection - it is a large file. 

```bash
  # Pull the Docker image
  docker pull katebelson05/breastwise:v1.0.0

```

Next, choose the appropriate run command, depending on whether you are running the image with or without a GPU. 

  ```bash

  # Run the Docker image (with GPU)
  docker run --gpus "device=0" -p 8000:8000 katebelson05/breastwise:v1.0.0

  # Run the Docker image (without GPU)
  docker run -p 8000:8000 katebelson05/breastwise:v1.0.0


```

Requests can then be made to the upload endpoint at localhost:8000/upload/ .

## Usage/Examples

The API request body should contain a folder called "series.zip". This folder should contain these folders: 
- pre
- 1st_pass
- 2nd_pass
- 3rd_pass
All three folders should contain the same number of DICOM breast MRI images for the relevant series type. The naming should match, ie each folder should contain a file called 001.dcm. 

The response will be in the form of an array, containing information on the slices that contain cancer. For example, [10, 11, 12] would indicate the 10th, 11th and 12th slices contain a tumour. 
## Tech 

Django is a high-level Python web framework that enables the rapid development of secure and maintainable websites. It follows the Model-View-Controller (MVC) architectural pattern, which allows for a clear separation of concerns between different parts of an application. Django manages the backend logic, handles database operations, and provides a templating system to generate HTML. The API has been adapted to be run with Docker. 

Docker is a software platform that allows developers to package and deploy applications in containers. Containers are lightweight, standalone, and executable packages that contain everything needed to run an application, including code, run-time, libraries, system tools, and settings

## Functions 

### post(self, request, *args, **kwargs) 

Defines what happens on a post request - data is unzipped and files are checked. 

### delete_folders()

Deletes temporary folders after use. 

### scan() 

Runs the code for MRI scan analysis, returning an array of scan slices containing cancer. 

### process_single(single_folder) 

Preprocesses data for analysis of fat saturated series images, contained in single_folder. 

### process_scantype(pass1_folder, pass2_folder, pass3_folder)

Preprocesses data for analysis of scantype (Phase 1, Phase 2 & Phase 3) series images, contained in the corresponding folders. 

### normalize(img)

Normalises image pixel values to range [0, 255]. 

### analyse_single()

Puts the fat saturated images through the VGG19 network and returns an array containing the results (0 for negative, 1 for positive). 

### analyse_scantype()

Puts the scantype (Phase 1, Phase 2 & Phase 3) images through the VGG19 network and returns an array containing the results (0 for negative, 1 for positive). 

### average_results(single_results, scantype_results)

Averages the two arrays; if both are 1 then the slice is cancerous, if both are 0 then the slice is non-cancerous, and if they disagree then the nearby slices are looked at and if at least one of those is positive then the slices is defined as positive, as tumour scan slices will be close togther. 
## Running Tests

To run the unit tests tests, run the following command in the breastiwse\app directory.

```bash
  python manage.py test
```


## Support

For support, email kate.belson@hotmail.com .


## License

[MIT](https://choosealicense.com/licenses/mit/)


## Authors

- [Kate Belson](https://github.com/kfb19)

