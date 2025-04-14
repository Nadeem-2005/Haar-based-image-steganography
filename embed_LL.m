function embedd_LL(cover_img_path, message, stego_img_path)
    % Read and convert the image to grayscale
    cover_img = im2double(rgb2gray(imread(cover_img_path)));
    
    % Apply DWT
    [cA, cH, cV, cD] = dwt2(cover_img, 'haar');
    
    % Convert message to binary
    message_ascii = uint8(message);
    message_bin = reshape(dec2bin(message_ascii, 8)', 1, []);
    len = length(message_bin);
    
    % Store message length for extraction (first 16 coefficients)
    len_bin = dec2bin(len, 16);
    for i = 1:16
        cA(i) = cA(i) + (str2double(len_bin(i)) * 0.01); % Use cA (LL) instead of cD
    end
    
    % Embed message into approximation coefficients (cA) instead of diagonal (cD)
    for i = 1:len
        if message_bin(i) == '1'
            cA(i+16) = cA(i+16) + 0.01; % Use cA (LL) instead of cD
        end
    end
    
    % Reconstruct the image using IDWT
    stego_img = idwt2(cA, cH, cV, cD, 'haar');
    
    % Ensure pixel values are within valid range [0,1]
    stego_img = min(max(stego_img, 0), 1);
    
    % Save the stego image with "_LL" suffix to differentiate
    [path, name, ext] = fileparts(stego_img_path);
    ll_stego_path = fullfile(path, [name '_LL' ext]);
    imwrite(stego_img, ll_stego_path);
    
    % Display Images
    figure;
    subplot(1,2,1), imshow(cover_img), title('Original Image');
    subplot(1,2,2), imshow(stego_img), title('Stego Image (LL Domain)');
    
    % Compute and display metrics
    mse = mean((stego_img - cover_img).^2, 'all');
    psnr = 10 * log10(1 / mse);
    %fprintf('MSE: %.6f\n', mse);
    fprintf('PSNR: %.2f dB\n', psnr);
    
    disp(['Message embedded in LL domain successfully! Saved as: ' ll_stego_path]);
end


embedd_LL('cover_image1.jpg', 'Hello, World !!', 'stego_image1.png');
embedd_LL('cover_image2.jpg', 'Hello, India !!', 'stego_image2.png');
embedd_LL('cover_image3.jpg', 'Hello, Tamil Nadu !!', 'stego_image3.png');
embedd_LL('cover_image4.jpg', 'Hello, Vellore !!', 'stego_image4.png');