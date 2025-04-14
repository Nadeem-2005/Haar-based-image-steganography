function extractt_LL(stego_img_path, cover_img_path, msg_length)
    % Read images and convert to grayscale
    stego_img = im2double(im2gray(imread(stego_img_path)));
    cover_img = im2double(im2gray(imread(cover_img_path)));
    
    % Apply DWT
    [cA_stego, ~, ~, ~] = dwt2(stego_img, 'haar');
    [cA_cover, ~, ~, ~] = dwt2(cover_img, 'haar');
    
    % Extract message length from first 16 coefficients
    len_bits = '';
    for i = 1:16
        diff = cA_stego(i) - cA_cover(i);
        if diff > 0.005
            len_bits = [len_bits, '1'];
        else
            len_bits = [len_bits, '0'];
        end
    end
    
    % Convert binary length to decimal
    msg_bit_length = bin2dec(len_bits);
    if msg_bit_length == 0 || isnan(msg_bit_length) || msg_bit_length > 1000
        % Fallback to provided length if extraction fails
        msg_bit_length = msg_length * 8;
    end
    
    % Extract embedded bits from LL domain
    extracted_bits = zeros(1, msg_bit_length);
    for i = 1:msg_bit_length
        diff = cA_stego(i+16) - cA_cover(i+16);
        if diff > 0.005
            extracted_bits(i) = 1;
        else
            extracted_bits(i) = 0;
        end
    end
    
    % Debug: Display first few extracted bits
    disp('Extracted Binary (first 16 bits):');
    disp(extracted_bits(1:min(16, length(extracted_bits))));
    
    % Ensure extracted bits are a multiple of 8
    num_bits = length(extracted_bits);
    trim_length = floor(num_bits / 8) * 8;
    extracted_bits = extracted_bits(1:trim_length);
    
    % Convert binary to text
    extracted_bin = reshape(char(extracted_bits + '0'), 8, [])';
    extracted_msg = char(bin2dec(extracted_bin))';
    
    % Compute Performance Metrics
    mse = mean((stego_img - cover_img).^2, 'all');
    psnr = 10 * log10(1 / mse);
    
    % Display Results
    disp(['Extracted Message from LL domain: ', extracted_msg]);
    fprintf('MSE: %.6f\n', mse);
    fprintf('PSNR: %.2f dB\n', psnr);
    
    % Display Images
    figure;
    subplot(1,2,1), imshow(stego_img), title('Stego Image (LL Domain)');
    subplot(1,2,2), imshow(cover_img), title('Original Image');
end

extractt_LL('stego_image1_LL.png', 'cover_image1.jpg', length('Hello, World !!'));
extractt_LL('stego_image2_LL.png', 'cover_image2.jpg', length('Hello, India !!'));
extractt_LL('stego_image3_LL.png', 'cover_image3.jpg', length('Hello, Tamil Nadu !!'));
extractt_LL('stego_image4_LL.png', 'cover_image4.jpg', length('Hello, Vellore !!'));