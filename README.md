# Naturalistic video reconstruction from brain activity

In this project, we aimed to enhance naturalistic video reconstruction methods by incorporating eye-tracking recordings of participants as they freely viewed movies. We used the studyforrest dataset, which contains fMRI and eye-tracking data of people viewing ‘Forrest Gump’ during a 2-hour fMRI session. The goal was to create video reconstructions that closely mimic actual viewing experiences.

The methodology involved several steps, including preprocessing movie frames based on eye gaze data, transforming BOLD responses from selected voxels into a tensor in pixel space, calculating receptive field locations and signals for voxels in the early visual cortex, generating targets for these receptive field signals, and matching the receptive field signals with their target frames.

I was involved in the project for four months before I had to return to Trento to continue my master’s degree. By that time, the project needed further work to improve the results. Preliminary findings suggested overfitting, likely due to the two-hour length of the film and the 2-second temporal resolution of the fMRI recordings.

You can find more details in ‘InternshipReport_23.02.2021_OrhanSoyuhos.pdf’.

### Dataset
Studyforrest dataset (https://www.studyforrest.org/).

## Code Structure

The pipeline is organized into three sequential stages:

### 1. Preprocessing Movie Frames (`code/1- Preprocessing Movie Frames/`)
MATLAB scripts that preprocess the raw movie frames using eye-tracking data:
- **`make masks/`** — Generates spatial masks by shifting a raw frame template according to per-subject gaze coordinates (averaged at 25 fps from 1000 Hz eye-tracking recordings) and cropping to a square target size.
- **`shifting frames/`** — Applies the gaze-based shifting to the actual movie frames, producing subject-specific video sequences centered on where each participant was looking.
- **`visualize eye gazes/`** — Overlays eye-gaze trajectories onto the video for inspection.

### 2. Generating Dataset (`code/2- Generating Dataset/`)
Jupyter notebooks that transform the preprocessed fMRI and movie data into training-ready tensors:
- Extracts and saves BOLD responses from the early visual cortex (VIS ROI).
- Computes receptive field (RF) locations and signals for each voxel in Cartesian coordinates.
- Generates target frames using retinal warping.
- Shifts and stacks fMRI data to align with the hemodynamic response delay.
- Splits data into training and testing sets.

### 3. Reconstructing Videos (`code/3- Reconstructing Videos/`)
Python scripts and notebooks that implement and run the GAN-based reconstruction model:
- **`generator_vgg.py`** — U-Net-style generator with skip connections. Loss is a weighted combination of adversarial loss, VGG19 perceptual loss (up to layer 22), and pixel-wise L1 loss.
- **`discriminator.py`** — PatchGAN discriminator with a history buffer (capacity 50) to stabilize training.
- **`modules.py`** — Data loading utilities: builds MXNet DataLoaders from preprocessed `.npy` files, maps RF signals into pixel space.
- **`train_model.py`** — Main training loop (default: 4000 epochs, batch size 8, Adam optimizer, lr=0.0002). Logs images and losses to TensorBoard via mxboard and saves model parameters after each epoch.
- **`make_video.py`** — Loads a trained generator and renders side-by-side comparison videos (RFS image | reconstruction | ground truth) for both training and test sets.
- **`tensorboard_results.py`** — Helper for visualizing training curves.

## Dependencies

| Component | Tools / Libraries |
|-----------|-------------------|
| Preprocessing | MATLAB (with `tdfread` for tab-delimited eye-tracking files) |
| Dataset generation | Python, Jupyter, NumPy |
| Model training & inference | Python, [Apache MXNet](https://mxnet.apache.org/), mxboard, VGG19 (pretrained, via `mxnet.gluon.model_zoo`) |
| Video export | imageio, matplotlib |
| Utilities | tqdm, glob |

## Setup

1. **Clone the repository** and download the [studyforrest dataset](https://www.studyforrest.org/).
2. **Update the data path** in `code/3- Reconstructing Videos/modules.py`:
   ```python
   # Line 32 — change this to your local studyforrest preprocessing directory
   rel_dir = ‘/your/path/to/studyforrest/Preprocessing steps’
   ```
3. **Install Python dependencies** (MXNet, mxboard, imageio, tqdm, numpy, matplotlib).
4. Run the stages in order: preprocessing (MATLAB) → dataset generation (notebooks) → training (`train_model.py`) → video export (`make_video.py`).

## Preliminary Results
       fixed RFSimage     |    reconstruction   |      ground truth

![frame](https://user-images.githubusercontent.com/44211738/159025612-467cd905-bff7-443b-bdb2-d867f484e188.PNG)

*RFSimage = receptive field signal image

### Training set
![whole_video_training](https://user-images.githubusercontent.com/44211738/159027779-0ebc0967-257d-4944-bc80-48be91707788.gif)

### Test set
![whole_video_testing](https://user-images.githubusercontent.com/44211738/159027941-1c8b8e28-5b16-4784-8a32-25e6f6175fff.gif)

### Eye tracking visualization (6 subjects)
https://user-images.githubusercontent.com/44211738/159038126-34da7a4f-9b02-4480-9a05-0317ad3938ba.mp4

https://youtu.be/4g3Oc2bZfpQ

### Shifted movie frames (subject 17)
https://user-images.githubusercontent.com/44211738/159060972-861e4197-abbb-4d0c-8e39-be32494c89a1.mp4

https://youtu.be/vN6WF19ulAE

## Acknowledgement
- This project was part of my research internship at the Donders AI for Neurotech Lab. I would like to thank Dr. Yağmur Güçlütürk, Dr. Umut Güçlü, and Lynn Le for their supervision during my training.
- The original code on GANs (brain2pix model; located inside `code/3- Reconstructing Videos/`) to reconstruct movie frames based on the code published here: https://github.com/neuralcodinglab/brain2pix. 
- Please see the paper for Brain2Pix model here: https://www.biorxiv.org/content/10.1101/2021.02.02.429430v2.abstract. 
