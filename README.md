<div align="center">
    <a href="http://www.dietrich-lab.org/vocalmat"><img src="resources/logo.gif" title="VocalMat - Dietrich Lab" alt="VocalMat - Dietrich Lab"></a>
</div>

<div align="center">
    <strong>Analysis of ultrasonic vocalizations from mice using computer vision and machine learning</strong>
</div>

<div align="center">
    <br />
    <!-- MATLAB version -->
    <a href="https://www.mathworks.com/products/matlab.html">
    <img src="https://img.shields.io/badge/MATLAB-2017%7C2018%7C2019%7C2020%7C2021-blue.svg?style=flat-square"
      alt="MATLAB tested versions" />
    </a>
    <!-- LICENSE -->
    <a href="#">
    <img src="https://img.shields.io/badge/license-Apache%202.0-orange.svg?style=flat-square"
      alt="Apache License 2.0" />
    </a>
    <br />
</div>

<br />

If you use VocalMat4Rats or any part of it in your own work, please cite: 
[Scott et al. 2024](https://doi.org/10.1121/10.0024340), and 
[Fonseca et al](https://www.biorxiv.org/content/10.1101/2020.05.20.105023v2):
```
@article{Fonseca2021AnalysisOU,
  title={Analysis of ultrasonic vocalizations from mice using computer vision and machine learning},
  author={Antonio H. O. Fonseca and Gustavo Madeira Santana and Gabriela M Bosque Ortiz and Sergio Bampi and Marcelo O. Dietrich},
  journal={eLife},
  year={2021},
  volume={10}
}
```
For more information, visit the VocalMat team's website: [VocalMat - Dietrich Lab](http://dietrich-lab.org/vocalmat)

Dataset and audios used in the original VocalMat paper are available at: [OSF Repository](https://osf.io/bk2uj/)\
Dataset for VocalMat4Rats will be available upon publication.

## Table of Contents
- [Description](#description)
- [Features](#features)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [Requirements](#requirements)
- [FAQ](#faq)
- [License](#license)

---

## Description
> **VocalMat4Rats is an automated tool that identifies and classifies 50-kHz range rat vocalizations.**

<p align="justify"> VocalMat is divided into two main components. The VocalMat Identifier, and the VocalMat Classifier.

![VocalMat Workflow](resources/vocalmat.png)

<p align="justify"> VocalMat <b>Identifier</b> detects vocalization candidates in the audio file. Vocalization candidates are detected through a series of image processing operations and differential geometry analysis over spectrogram information. The VocalMat Identifier outputs (optional) a MATLAB formatted file (.MAT) with information about the spectral content of detected vocalizations (e.g., frequency, intensity, timestamp), that is later used by the VocalMat Classifier.

<p align="justify"> VocalMat <b>Classifier</b> uses a Convolutional Neural Network (CNN) to classify each short vocalization candidate into 12 distinct labels: Complex, Complex trill, Downward ramp, Flat, Inverted-U, Short, Split, Step down, Step up, Trill, Upward ramp, and noise.

![VocalMat labels](resources/schema_fixed_greyscale.png)

## Features
- __11 Classification Classes:__ VocalMat is able to distinguish between 11 classes of vocalizations (see Figure above), according to adapted definitions from [Wright et al. (2010)](https://link.springer.com/article/10.1007/s00213-010-1859-y).
- __Noise Detection:__ eliminates vocalization candidates associated to mechanical or segmentation noise.
- __Harmonic Detection:__ detects vocalizations with components overlapping in time.
- __Fast Performance:__ optimized versions for personal computers and high-performance computing (clusters)

## What's different in VM4Rats
- __Signal detection changes:__ Increased time of absent signal for VM to determine the following signal to be a new USV, to account for species differences in vocalizations.
- __Minimum frequency threshold:__ At ~line 140 in VM identifier routine, we've set a minimum threshold at 30kHz to exclude 22-kHz aversives, this can be modified at your leisure
- __Wright et al. 2010 style classifiers:__ VM4Rats Uses our classification scheme for rat USVs, if you wish to train a new model using our classification scheme, see the training routine train_model_Rat
- __Note:__ Clustering and diffusion maps are currently disabled for this version of VocalMat4Rats as these were throwing errors.
- __Synthetic training data creation routine:__ Create your own synthetic training data images with our USV_morpher.m routine, which takes as input images created through VocalMat. Note that you need to check these images for likeness before including them in your training set.

## Coming soon

## Getting Started
![Recordit GIF](resources/clone.gif)

**You must have Git LFS installed to be able to fully clone the repository. [Download Git LFS](https://git-lfs.github.com/)**

**If in doubt, proceed to the ```Manual Download``` section**

#### Latest Stable Version
```bash
$ git clone https://github.com/scoki211/VocalMat4Rats.git
```

#### Latest (Unreleased) Version
```bash
$ git clone -b VocalMat_RC --single-branch https://github.com/scoki211/VocalMat4Rats.git
```

##### Using a Git client
You can use a Git client to clone our repository, we recommend GitHub's own client:

```Download at:``` [https://desktop.github.com](https://desktop.github.com)

##### Manual download
You can download VocalMat by using GitHub's `Download Zip` option. However, since we use Git LFS (Git Large File Storage), a necessary file will not be downloaded

> Download this repository as a zip file: [Download Zip](https://github.com/scoki211/VocalMat4Rats/archive/master.zip)

Extract the `.zip` file. This is the VocalMat directory.

> Download the neural network model file: [Download Model](https://osf.io/s4g2j)

Place the model file in the `vocalmat_classifier` folder inside the VocalMat directory.

#### Directory Structure
- __vocalmat_identifier:__ Directory with all files and scripts related to the VocalMat Identifier
- __vocalmat_classifier:__ Directory with all files and scripts related to the VocalMat Classifier
- __audios:__ Directory with audio files you want to analyze in the `audios` directory

## Usage

#### `VocalMat` Manual Execution
<p align="justify">Navigate to the VocalMat directory in MATLAB and run <i>VocalMat.m</i> by either opening the file or typing <i>VocalMat</i> in MATLAB's command window. Once VocalMat is running, choose the audio file you want to analyze. An example audio file is provided, and you can use it to test VocalMat.

<!-- The <i>Identifier</i> will output two .MAT files in the same directory that the audio file is in, <i>output_*.mat</i> (which contains the spectrograms content and detailed spectral features for each vocalization) and <i>output_shorter_*.mat</i> (same information, except the spectrogram content). The <i>Classifier</i> will create a directory with its outputs (vocalizations and classifications) in that same directory that the audio file is in. -->

#### `VocalMat` Output Files

<p align="justify">VocalMat outputs a directory with the same name as the audio file that was analyzed. Inside that directory there will be two directories (<i>All</i>, and <i>All_axes</i> if <i>save_plot_spectrograms=1</i>), and two Microsoft Excel (.xlsx) files. Inside <i>All_axes</i> you will find one image for each vocalization candidate detetcted with the resulting segmentation illusrated by blue circles. The raw original images are available inside <i>All</i>. The main Excel file has the same name of the audio file analyzed (<i>audio_file_name</i>.xlsx). This file contains information on each vocalization, such as start and end time, duration, frequency (minimum, mean and maximum), bandwidth, intensity (minimum, mean, maximum and corrected based on the backgroun), existence of harmonic components or distortions (noisy), and call type. The second excel file named as <i>audio_file_name</i>_DL.xlsx shows the probability distribution for each vocalization candidate for the different vocal classes.

#### Training your own network
While these data that were reported in [Scott et al. 2024](https://doi.org/10.1121/10.0024340) were suitable for our needs under low noise conditions, it should be noted that differences in recording conditions, microphone gain and recording paradigm may lead to different levels of performance. Thus, training of your own network (utilizing images created through VocalMat audio processing) may be a desirable option. You can access the training routine through VocalMat4Rats-master > vocalmat_classifier > training > train_model_Rat. You will see at line 21 you will need to specify the folder where your images are located. From line 75 you will need to specify your desired classification schema, if you wish to change it from the present one. The folder where your images are located should have a subfolder for each classification category specified, within which is contained your training images. If adjusting classification schema, you will also need to adjust the routine vocalmat_classifier.m before it will run successfully, to do so you will need to adjust classifiers from line 52 and again from line 348. Included in this repo is now the USV_morpher.m routine, which allows you to create synthetic training data from a VocalMat USV image (found in the 'all' folder from the VocalMat output).

#### Adjusting frequency cut-off
We have included a frequency cut-off at 30-kHz as standard, but you may wish to modify this to suite your needs, to do so open vocalmat_identfier, under the vocalmat_identifier subfolder of the master, navigate to ~line 140. Replace F>30000 with whatever you find suitable, for instance if you want VocalMat to ignore detections below 25kHz you would write F>25000 

<!-- #### Personal Use (bash script, linux-based systems)
```bash
$ ./run_identifier_local [OPTIONS]
```
##### Examples
VocalMat help menu
```bash
$ ./run_identifier_local -h
or
$ ./run_identifier_local --help
```
Running VocalMat using 4 threads:
```bash
$ ./run_identifier_local -c 4
or
$ ./run_identifier_local --cores 4
```

#### High-Performance Computing (Clusters with Slurm Support, bash script)
```bash
$ ./run_identifier_cluster [OPTIONS]
```
##### Examples
Running VocalMat and getting execution (slurm) notifications to your email:
```bash
$ ./run_identifier_cluster -e your@email.com
or
$ ./run_identifier_cluster --email your@email.com
```

Running VocalMat using 4 cores, 128GB of RAM, walltime of 600 minutes, and getting notifications to your email:
```bash
$ ./run_identifier_cluster -e your@email.com -c 4 -m 128 -t 600
or
$ ./run_identifier_cluster --email your@email.com --cores 4 --mem 128 --time 600
``` -->

## Requirements
##### Recordings
- __Recording protocol:__ follow the protocol established by [Ferhat et al, 2016](https://www.jove.com/pdf/53871/jove-protocol-53871-recording-mouse-ultrasonic-vocalizations-to-evaluate-social).
- __Sampling rate:__ we recommend using a sampling rate of 250kHz (Fmax=125kHz).

##### Software Requirements
- __MATLAB:__ versions 2017a through 2019b. For other versions refer to the [FAQ](#faq).
- __MATLAB Add-Ons:__
    - Signal Processing Toolbox
    - Deep Learning Toolbox
    - Image Processing Toolbox
    - Statistics and Machine Learning Toolbox

## FAQ
- Will `VocalMat` work with my MATLAB version?
<p align="justify">VocalMat was developed and tested using MATLAB 2017a through 2019b versions. We cannot guarantee that it will work in other versions of MATLAB. If your MATLAB version supports all the required Add-Ons, VocalMat should work. It should be noted that VM4Rats was adapted and trained using MATLAB 2020b - 2021b on Windows 10.

- What are the hardware requirements to run `VocalMat`?
<p align="justify">The duration of the audio files that can be processed in VocalMat is limited to the amount of RAM your computer has. We estimate around 1GB of RAM for every minute of recording using one minute segments. For a 10 minute recording, your computer should have at least 10GB of RAM available. RAM usage will vary depending on your MATLAB version and computer, these numbers are just estimates.

- Will `VocalMat` work with my HPC Cluster?
<p align="justify"> In order for our script to work in your Cluster it must have Slurm support. Minor changes might have to be made to adapt the script to your Cluster configuration.

- I want a new feature for `VocalMat`, can I contribute?
<p align="justify"> Yes! If you like VocalMat and want to help us add new features, please create a pull request!

<!-- version-control: 1.0 -->
