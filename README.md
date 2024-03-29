# Naturalistic-Video-Reconstruction-From-Brain-Activity

In this project, we aimed to enhance naturalistic video reconstruction methods by incorporating eye-tracking recordings of participants as they freely viewed movies. We used the studyforrest dataset, which contains fMRI and eye-tracking data of people viewing 'Forrest Gump' during a 2-hour fMRI session. The goal was to create video reconstructions that closely mimic actual viewing experiences.

The methodology involved several steps, including preprocessing movie frames based on eye gaze data, transforming BOLD responses from selected voxels into a tensor in pixel space, calculating receptive field locations and signals for voxels in the early visual cortex, generating targets for these receptive field signals, and matching the receptive field signals with their target frames.

I was involved in the project for four months before I had to return to Trento to continue my master’s degree. By that time, the project needed further work to enhance the results. Preliminary findings suggested a potential challenge of overfitting, due to the two-hour length of the film and the 2-second temporal resolution of the fMRI recordings.

You can find more details in 'InternshipReport_23.02.2021_OrhanSoyuhos.pdf'.

### Dataset
Studyforrest dataset (https://www.studyforrest.org/).

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
- This project was part of my research internship at Donders AI for Neurotech Lab (https://ai4neuro.tech/). I would like to thank and acknowlege Dr. Yağmur Güçlütürk, Dr. Umut Güçlü and Lynn Le's supervison during my training.
- The original code on GANs (brain2pix model; located inside code/Reconstructing Videos/) to reconstruct movie frames belongs to Lynn Le and is published here (https://github.com/neuralcodinglab/brain2pix). 
- You can check their paper on Brain2Pix model (https://www.biorxiv.org/content/10.1101/2021.02.02.429430v2.abstract) for further explanation. 
