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

### 2. Run the Code

In MATLAB:

```matlab
% Basic embedding and extraction (HH domain)
embedd('cover_image1.jpg', 'Hello, World !!', 'stego_image1.png');
extractt('stego_image1.png', 'cover_image1.jpg', length('Hello, World !!'));

% LL domain embedding and extraction
embedd_LL('cover_image1.jpg', 'Hello, World !!', 'stego_image1.png');
extractt_LL('stego_image1_LL.png', 'cover_image1.jpg', length('Hello, World !!'));

% Robustness testing against attacks
attackk('stego_image1.png', 'cover_image1.jpg');

## 📂 Project Structure

