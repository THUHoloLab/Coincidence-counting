<div align="center">
<h1> Coincidence counting of quantum Gabor holography </h1>

**[Yiqian Yang](https://scholar.google.com/citations?user=98z1r7MAAAAJ&hl=zh-TW&oi=ao)** and **[Liangcai Cao](https://scholar.google.com/citations?user=FYYb_-wAAAAJ&hl=en)**

:school: ***[HoloLab](http://www.holoddd.com/)**, Tsinghua University*

</div>

This work demonstrates array-based coincidence counting with joint probability analysis to directly extract the spatial correlations of entangled photon pairs. The ability of array detectors to simultaneously provide both arrival-time and spatial information enables multidimensional correlation filtering and facilitates sub-shot-noise imaging. The code selectively identifies genuine photon-pair events while effectively suppressing uncorrelated background photons and detector noise. The output coincidence map (CM) directly reveals the underlying spatial correlation structure of the entangled photon pairs, providing a high-fidelity representation of their quantum correlations and serving as a robust foundation for advanced applications such as quantum imaging and quantum metrology.

<p align="left">
<img src="imgs/Theory.jpg", width='800'>
</p>

## Reference
-  Yiqian Yang, Yunhui Gao, Jiachen Wu, Liangcai Cao, "Coincidence counting of quantum Gabor holography," Laser & Photonics Reviews (2026): e71223.
-  https://doi.org/10.1002/lpor.71223

## Requirements
-  MATLAB R2022a or newer versions

## Array-based coincidence-counting algorithm
-  Only coincident detections, which occur within the same frame at two spatially symmetric pixels, contribute to the correlation signal. For entangled photon pairs generated via spontaneous parametric down-conversion (SPDC), this method isolates the non-classical correlations that uniquely reveal the pairwise nature of the photon emission process. In quantum imaging, this coincidence counting approach preferentially selects correlated photon-pair events while suppressing uncorrelated background light and detector noise. The one-dimensional joint probability distribution (JPD) and two-dimensional CM provide a statistical framework that improves robustness of coincidence extraction and information retrieval for quantum Gabor holography (QGH). 

<p align="left">
<img src="imgs/Coincidence_Counting.jpg", width='800'>
<p align="left">

## Source
-  The simulation and experiment original measurement image

## Contact
-  Yiqian Yang, yang-yq22@mails.tsinghua.edu.cn
-  Liangcai Cao, clc@tsinghua.edu.cn



