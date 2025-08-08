# DWT-Based Image Steganography and Robustness Analysis

This MATLAB project implements image steganography using the **Discrete Wavelet Transform (DWT)**. It allows users to embed and extract secret messages in grayscale images, evaluate the imperceptibility and robustness of the stego images, and analyze the impact of various common image processing attacks.

---

## 📌 Features

- ✅ **Message Embedding** in both **Diagonal (HH)** and **Approximation (LL)** wavelet domains.
- 🔓 **Message Extraction** with or without prior message length.
- 📐 **Imperceptibility Metrics**: PSNR, SNR, and SSIM.
- 🛡️ **Robustness Testing** against:
  - Gaussian noise
  - Salt & pepper noise
  - Median filtering
  - Gaussian blur
  - JPEG compression
  - Rotation
  - Scaling
  - Gamma correction
  - Histogram equalization
  - Cropping
- 📊 **Visual Analysis**:
  - Stego images
  - LL and HH domain comparison
  - Graphs for PSNR, SNR, SSIM
  - Text-based metric tables

---

## 🧠 Techniques Used

- **Discrete Wavelet Transform (DWT - Haar)** for decomposing images into frequency subbands.
- **Bitwise Embedding**: Converts messages to binary and subtly alters wavelet coefficients.
- **Inverse DWT (IDWT)** to reconstruct stego images.
- **Performance Evaluation**: PSNR, SNR, SSIM across image, LL, and HH domains.

---


---

## 🚀 How to Run

### 1. Prerequisites

- MATLAB R2018b or newer
- Image Processing Toolbox

Sample Output:
PSNR: 43.12 dB
Extracted Message: Hello, World !!
MSE: 0.000123
SSIM: 0.9987
Domain Robustness Analysis:
LL domain appears more robust against attacks

## 🚀 How to Run

In MATLAB:

```matlab
% Basic embedding and extraction (HH domain)
embedd('cover_image1.jpg', 'Hello, World !!', 'stego_image1.png');
extractt('stego_image1.png', 'cover_image1.jpg', length('Hello, World !!'));

% LL domain embedding and extraction
embedd_LL('cover_image1.jpg', 'Hello, World !!', 'stego_image1_LL.png');
extractt_LL('stego_image1_LL.png', 'cover_image1.jpg', length('Hello, World !!'));

% Robustness testing against attacks
attackk('stego_image1.png', 'cover_image1.jpg');
```

You can also run multiple samples using the batch calls at the bottom of the script.

---

## 📈 Sample Output (Text Console)

```
PSNR: 43.12 dB  
Extracted Message: Hello, World !!  
MSE: 0.000123  
SSIM: 0.9987  

Domain Robustness Analysis:  
LL domain appears more robust against attacks
```

---

## ⚠️ Limitations

- Designed for grayscale images (RGB gets auto-converted).
- Embedding capacity depends on image size and DWT domain.
- Not resistant to very heavy image distortions or cropping.

---

## 🔮 Future Work

- Add color image support (e.g., RGB channels or YCbCr).
- GUI-based interface for ease of use.
- Auto-testing framework for attacks + reporting.

---

## 🧑‍💻 Author

Kishore

---

## 📄 License

This project is licensed under the **MIT License**. See the `LICENSE` file for details.

---

## 💬 Acknowledgments

- DWT-based image processing inspired by academic research  
- MATLAB documentation and community resources  
- Image Processing Toolbox (MathWorks)

---

## 🏷️ Tags

`matlab` `steganography` `wavelet` `dwt` `psnr` `ssim` `image-processing` `robustness`


