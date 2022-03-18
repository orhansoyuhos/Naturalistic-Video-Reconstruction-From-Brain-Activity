# Naturalistic-Video-Reconstruction-From-Brain-Activity
Based on the subject's eye-tracking data, my research aimed to enable naturalistic video reconstruction from the brain data of participants who have free-viewed movies during fMRI recording (studyforrest dataset).

## Initial Results
After 4 months, I had to return to Trento to start my thesis project and could not finalize the project. You can see the initials results below. I believe a two-hour-long movie was not enough to prevent the problem of overfitting, especially when the TR time of fMRI recordings were 2 seconds.   

       fixed RFSimage     |    reconstruction   |      ground truth

![frame](https://user-images.githubusercontent.com/44211738/159025612-467cd905-bff7-443b-bdb2-d867f484e188.PNG)

### Training set
![whole_video_training](https://user-images.githubusercontent.com/44211738/159027779-0ebc0967-257d-4944-bc80-48be91707788.gif)

### Test set
![whole_video_testing](https://user-images.githubusercontent.com/44211738/159027941-1c8b8e28-5b16-4784-8a32-25e6f6175fff.gif)


## Acknowledgement
This project was part of my research internship at Donders AI for Neurotech Lab (https://ai4neuro.tech/). I would like to acknowlege Dr. Yağmur Güçlütürk, Dr. Umut Güçlü and Lynn Le's supervison during my training. In particular, the original code on GANs (brain2pix model; located inside code/Reconstructing Videos/) to reconstruct movie frames belongs to Lynn Le and is published here (https://github.com/neuralcodinglab/brain2pix). You can also check their paper on Brain2Pix here (https://www.biorxiv.org/content/10.1101/2021.02.02.429430v2.abstract) for further explanation on the model. 

