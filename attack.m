function attackk(stego_img_path, cover_img_path)
    % Check if files exist
    if ~exist(stego_img_path, 'file')
        error('Stego image not found: %s\nMake sure to run embedd() first to create the stego images.', stego_img_path);
    end
    if ~exist(cover_img_path, 'file')
        error('Cover image not found: %s', cover_img_path);
    end
    
    % Read the stego and cover images
    stego_img = im2double(im2gray(imread(stego_img_path)));
    cover_img = im2double(im2gray(imread(cover_img_path)));
    original_stego = stego_img; % Keep a copy of the original stego image
    
    % Apply DWT to get domains for original images
    [LL_stego, HL_stego, LH_stego, HH_stego] = dwt2(stego_img, 'haar');
    [LL_cover, HL_cover, LH_cover, HH_cover] = dwt2(cover_img, 'haar');
    
    % Create a figure to display all attacked images
    figure('Name', ['Attacks on ' stego_img_path], 'Position', [100, 100, 1400, 900]);
    
    % Display original stego image
    subplot(4, 4, 1);
    imshow(stego_img);
    title('Original Stego Image');
    
    % Initialize table for metrics (Image domain, LL domain, and HH domain)
    attack_names = {'Original', 'Gaussian Noise', 'Salt & Pepper', 'Median Filter', ...
                   'Gaussian Blur', 'JPEG Compression', 'Rotation', ...
                   'Scaling', 'Gamma Correction', 'Histogram Equalization', 'Cropping'};
    metrics_img = zeros(length(attack_names), 3); % PSNR, SNR, SSIM for Image domain
    metrics_ll = zeros(length(attack_names), 3);  % PSNR, SNR, SSIM for LL domain
    metrics_hh = zeros(length(attack_names), 3);  % PSNR, SNR, SSIM for HH domain
    
    % Calculate metrics for original (baseline)
    metrics_img(1,1) = Inf; % PSNR (original vs original)
    metrics_img(1,2) = Inf; % SNR (original vs original)
    metrics_img(1,3) = 1.0; % SSIM (original vs original)
    metrics_ll(1,:) = [Inf, Inf, 1.0];
    metrics_hh(1,:) = [Inf, Inf, 1.0];
    
    % Store attacked images and their DWT coefficients
    attacked_images = cell(length(attack_names), 1);
    attacked_ll = cell(length(attack_names), 1);
    attacked_hh = cell(length(attack_names), 1);
    
    % Attack 1: Gaussian Noise
    attacked_img = imnoise(stego_img, 'gaussian', 0, 0.001);
    subplot(4, 4, 2);
    imshow(attacked_img);
    title('Gaussian Noise');
    [LL_attacked, ~, ~, HH_attacked] = dwt2(attacked_img, 'haar');
    metrics_img(2,:) = calculate_metrics(original_stego, attacked_img);
    metrics_ll(2,:) = calculate_metrics(LL_stego, LL_attacked);
    metrics_hh(2,:) = calculate_metrics(HH_stego, HH_attacked);
    attacked_images{2} = attacked_img;
    attacked_ll{2} = LL_attacked;
    attacked_hh{2} = HH_attacked;
    
    % Attack 2: Salt & Pepper Noise
    attacked_img = imnoise(stego_img, 'salt & pepper', 0.01);
    subplot(4, 4, 3);
    imshow(attacked_img);
    title('Salt & Pepper Noise');
    [LL_attacked, ~, ~, HH_attacked] = dwt2(attacked_img, 'haar');
    metrics_img(3,:) = calculate_metrics(original_stego, attacked_img);
    metrics_ll(3,:) = calculate_metrics(LL_stego, LL_attacked);
    metrics_hh(3,:) = calculate_metrics(HH_stego, HH_attacked);
    attacked_images{3} = attacked_img;
    attacked_ll{3} = LL_attacked;
    attacked_hh{3} = HH_attacked;
    
    % Attack 3: Median Filtering
    if size(stego_img, 3) == 3
        % For RGB images
        attacked_img = stego_img;
        for i = 1:3
            attacked_img(:,:,i) = medfilt2(stego_img(:,:,i), [3 3]);
        end
    else
        % For grayscale images
        attacked_img = medfilt2(stego_img, [3 3]);
    end
    subplot(4, 4, 4);
    imshow(attacked_img);
    title('Median Filter (3x3)');
    [LL_attacked, ~, ~, HH_attacked] = dwt2(attacked_img, 'haar');
    metrics_img(4,:) = calculate_metrics(original_stego, attacked_img);
    metrics_ll(4,:) = calculate_metrics(LL_stego, LL_attacked);
    metrics_hh(4,:) = calculate_metrics(HH_stego, HH_attacked);
    attacked_images{4} = attacked_img;
    attacked_ll{4} = LL_attacked;
    attacked_hh{4} = HH_attacked;
    
    % Attack 4: Gaussian Blur
    h = fspecial('gaussian', [5 5], 2);
    attacked_img = imfilter(stego_img, h);
    subplot(4, 4, 5);
    imshow(attacked_img);
    title('Gaussian Blur');
    [LL_attacked, ~, ~, HH_attacked] = dwt2(attacked_img, 'haar');
    metrics_img(5,:) = calculate_metrics(original_stego, attacked_img);
    metrics_ll(5,:) = calculate_metrics(LL_stego, LL_attacked);
    metrics_hh(5,:) = calculate_metrics(HH_stego, HH_attacked);
    attacked_images{5} = attacked_img;
    attacked_ll{5} = LL_attacked;
    attacked_hh{5} = HH_attacked;
    
    % Attack 5: JPEG Compression Simulation
    % Save as temporary JPEG and reload (with compression)
    temp_jpg = [tempname '.jpg'];
    imwrite(stego_img, temp_jpg, 'jpg', 'Quality', 80);
    attacked_img = im2double(imread(temp_jpg));
    delete(temp_jpg); % Clean up temp file
    subplot(4, 4, 6);
    imshow(attacked_img);
    title('JPEG Compression (Q=80)');
    [LL_attacked, ~, ~, HH_attacked] = dwt2(attacked_img, 'haar');
    metrics_img(6,:) = calculate_metrics(original_stego, attacked_img);
    metrics_ll(6,:) = calculate_metrics(LL_stego, LL_attacked);
    metrics_hh(6,:) = calculate_metrics(HH_stego, HH_attacked);
    attacked_images{6} = attacked_img;
    attacked_ll{6} = LL_attacked;
    attacked_hh{6} = HH_attacked;
    
    % Attack 6: Rotation
    attacked_img = imrotate(stego_img, 2, 'bilinear', 'crop');
    subplot(4, 4, 7);
    imshow(attacked_img);
    title('Rotation (2°)');
    [LL_attacked, ~, ~, HH_attacked] = dwt2(attacked_img, 'haar');
    metrics_img(7,:) = calculate_metrics(original_stego, attacked_img);
    metrics_ll(7,:) = calculate_metrics(LL_stego, LL_attacked);
    metrics_hh(7,:) = calculate_metrics(HH_stego, HH_attacked);
    attacked_images{7} = attacked_img;
    attacked_ll{7} = LL_attacked;
    attacked_hh{7} = HH_attacked;
    
    % Attack 7: Scaling (resize down then up)
    [rows, cols, ~] = size(stego_img);
    small = imresize(stego_img, 0.5);
    attacked_img = imresize(small, [rows, cols]);
    subplot(4, 4, 8);
    imshow(attacked_img);
    title('Scaling (50% → 100%)');
    [LL_attacked, ~, ~, HH_attacked] = dwt2(attacked_img, 'haar');
    metrics_img(8,:) = calculate_metrics(original_stego, attacked_img);
    metrics_ll(8,:) = calculate_metrics(LL_stego, LL_attacked);
    metrics_hh(8,:) = calculate_metrics(HH_stego, HH_attacked);
    attacked_images{8} = attacked_img;
    attacked_ll{8} = LL_attacked;
    attacked_hh{8} = HH_attacked;
    
    % Attack 8: Gamma Correction
    gamma = 1.5;
    attacked_img = stego_img.^gamma;
    subplot(4, 4, 9);
    imshow(attacked_img);
    title(['Gamma Correction (γ=' num2str(gamma) ')']);
    [LL_attacked, ~, ~, HH_attacked] = dwt2(attacked_img, 'haar');
    metrics_img(9,:) = calculate_metrics(original_stego, attacked_img);
    metrics_ll(9,:) = calculate_metrics(LL_stego, LL_attacked);
    metrics_hh(9,:) = calculate_metrics(HH_stego, HH_attacked);
    attacked_images{9} = attacked_img;
    attacked_ll{9} = LL_attacked;
    attacked_hh{9} = HH_attacked;
    
    % Attack 9: Histogram Equalization
    if size(stego_img, 3) == 3
        % For RGB images, convert to HSV, equalize V, convert back
        hsv_img = rgb2hsv(stego_img);
        hsv_img(:,:,3) = histeq(hsv_img(:,:,3));
        attacked_img = hsv2rgb(hsv_img);
    else
        % For grayscale images
        attacked_img = histeq(stego_img);
    end
    subplot(4, 4, 10);
    imshow(attacked_img);
    title('Histogram Equalization');
    [LL_attacked, ~, ~, HH_attacked] = dwt2(attacked_img, 'haar');
    metrics_img(10,:) = calculate_metrics(original_stego, attacked_img);
    metrics_ll(10,:) = calculate_metrics(LL_stego, LL_attacked);
    metrics_hh(10,:) = calculate_metrics(HH_stego, HH_attacked);
    attacked_images{10} = attacked_img;
    attacked_ll{10} = LL_attacked;
    attacked_hh{10} = HH_attacked;
    
    % Attack 10: Cropping (crop 5% from each side and resize back)
    [rows, cols, ~] = size(stego_img);
    r_crop = round(rows * 0.05);
    c_crop = round(cols * 0.05);
    cropped = stego_img(r_crop:end-r_crop, c_crop:end-c_crop, :);
    attacked_img = imresize(cropped, [rows, cols]);
    subplot(4, 4, 11);
    imshow(attacked_img);
    title('Cropping (5%) & Resize');
    [LL_attacked, ~, ~, HH_attacked] = dwt2(attacked_img, 'haar');
    metrics_img(11,:) = calculate_metrics(original_stego, attacked_img);
    metrics_ll(11,:) = calculate_metrics(LL_stego, LL_attacked);
    metrics_hh(11,:) = calculate_metrics(HH_stego, HH_attacked);
    attacked_images{11} = attacked_img;
    attacked_ll{11} = LL_attacked;
    attacked_hh{11} = HH_attacked;
    
    % Display LL and HH domains of original image
    subplot(4, 4, 13);
    imshow(LL_stego, []);
    title('LL Domain (Original)');
    
    subplot(4, 4, 14);
    imshow(HH_stego, []);
    title('HH Domain (Original)');
    
    % Display comparison of domains after a typical attack (e.g., JPEG compression)
    subplot(4, 4, 15);
    imshow(attacked_ll{6}, []);
    title('LL Domain (After JPEG)');
    
    subplot(4, 4, 16);
    imshow(attacked_hh{6}, []);
    title('HH Domain (After JPEG)');
    
    % Create tables with metrics
    T_img = table(attack_names', metrics_img(:,1), metrics_img(:,2), metrics_img(:,3), ...
        'VariableNames', {'Attack', 'PSNR', 'SNR', 'SSIM'});
    
    T_ll = table(attack_names', metrics_ll(:,1), metrics_ll(:,2), metrics_ll(:,3), ...
        'VariableNames', {'Attack', 'PSNR', 'SNR', 'SSIM'});
    
    T_hh = table(attack_names', metrics_hh(:,1), metrics_hh(:,2), metrics_hh(:,3), ...
        'VariableNames', {'Attack', 'PSNR', 'SNR', 'SSIM'});
    
    % Create a new figure for the metrics tables
    figure('Name', ['Attack Metrics for ' stego_img_path], 'Position', [150, 150, 1200, 600]);
    
    % Display the tables
    subplot(1, 3, 1);
    axis off;
    text(0.1, 0.95, 'Image Domain Metrics', 'FontSize', 14, 'FontWeight', 'bold');
    format_and_display_table(T_img);
    
    subplot(1, 3, 2);
    axis off;
    text(0.1, 0.95, 'LL Domain Metrics', 'FontSize', 14, 'FontWeight', 'bold');
    format_and_display_table(T_ll);
    
    subplot(1, 3, 3);
    axis off;
    text(0.1, 0.95, 'HH Domain Metrics', 'FontSize', 14, 'FontWeight', 'bold');
    format_and_display_table(T_hh);
    
    % Create a figure to show domain comparison
    figure('Name', ['Domain Comparison for ' stego_img_path], 'Position', [200, 200, 900, 700]);
    
    % Plot PSNR comparison graph
    subplot(3, 1, 1);
    bar([metrics_img(:,1), metrics_ll(:,1), metrics_hh(:,1)]);
    title('PSNR Comparison Across Domains');
    xlabel('Attack Type');
    ylabel('PSNR (dB)');
    set(gca, 'XTick', 1:length(attack_names));
    set(gca, 'XTickLabel', attack_names);
    xtickangle(45);
    legend('Image Domain', 'LL Domain', 'HH Domain');
    grid on;
    
    % Plot SNR comparison graph
    subplot(3, 1, 2);
    bar([metrics_img(:,2), metrics_ll(:,2), metrics_hh(:,2)]);
    title('SNR Comparison Across Domains');
    xlabel('Attack Type');
    ylabel('SNR (dB)');
    set(gca, 'XTick', 1:length(attack_names));
    set(gca, 'XTickLabel', attack_names);
    xtickangle(45);
    legend('Image Domain', 'LL Domain', 'HH Domain');
    grid on;
    
    % Plot SSIM comparison graph
    subplot(3, 1, 3);
    bar([metrics_img(:,3), metrics_ll(:,3), metrics_hh(:,3)]);
    title('SSIM Comparison Across Domains');
    xlabel('Attack Type');
    ylabel('SSIM');
    set(gca, 'XTick', 1:length(attack_names));
    set(gca, 'XTickLabel', attack_names);
    xtickangle(45);
    legend('Image Domain', 'LL Domain', 'HH Domain');
    grid on;
    
    % Display the metrics in console
    disp(['Attack Metrics for ' stego_img_path ' - Image Domain:']);
    disp(T_img);
    disp(['Attack Metrics for ' stego_img_path ' - LL Domain:']);
    disp(T_ll);
    disp(['Attack Metrics for ' stego_img_path ' - HH Domain:']);
    disp(T_hh);
    
    % Output summary
    domain_comparison = calculate_domain_robustness(metrics_ll, metrics_hh);
    disp('Domain Robustness Analysis:');
    disp(domain_comparison);
end

function metrics = calculate_metrics(original, attacked)
    % Calculate PSNR (Peak Signal-to-Noise Ratio)
    mse = mean((original(:) - attacked(:)).^2);
    psnr = 10 * log10(1 / mse);
    
    % Calculate SNR (Signal-to-Noise Ratio)
    signal_power = mean(original(:).^2);
    noise_power = mse;
    snr = 10 * log10(signal_power / noise_power);
    
    % Calculate SSIM (Structural Similarity Index)
    if size(original, 3) == 3
        % For RGB images, calculate SSIM for each channel and average
        ssim_val = 0;
        for i = 1:3
            ssim_val = ssim_val + ssim(original(:,:,i), attacked(:,:,i));
        end
        ssim_val = ssim_val / 3;
    else
        % For grayscale images
        ssim_val = ssim(original, attacked);
    end
    
    metrics = [psnr, snr, ssim_val];
end

function format_and_display_table(T)
    % Format the table as text and display it
    table_str = '';
    for i = 1:height(T)
        if i == 1
            table_str = sprintf('%s%-20s %7s %7s %7s\n', table_str, 'Attack', 'PSNR', 'SNR', 'SSIM');
            table_str = sprintf('%s%s\n', table_str, repmat('-', 1, 45));
        end
        
        % Format metrics
        if isinf(T.PSNR(i))
            psnr_str = 'Inf';
            snr_str = 'Inf';
        else
            psnr_str = sprintf('%7.2f', T.PSNR(i));
            snr_str = sprintf('%7.2f', T.SNR(i));
        end
        ssim_str = sprintf('%7.4f', T.SSIM(i));
        
        table_str = sprintf('%s%-20s %s %s %s\n', table_str, T.Attack{i}, psnr_str, snr_str, ssim_str);
    end
    
    text(0.1, 0.9, table_str, 'FontSize', 9, 'FontName', 'Courier', 'VerticalAlignment', 'top');
end

function result = calculate_domain_robustness(metrics_ll, metrics_hh)
    % Compare robustness of LL vs HH domains
    % Skip the first row (original)
    ll_avg_psnr = mean(metrics_ll(2:end, 1));
    hh_avg_psnr = mean(metrics_hh(2:end, 1));
    
    ll_avg_ssim = mean(metrics_ll(2:end, 3));
    hh_avg_ssim = mean(metrics_hh(2:end, 3));
    
    % Count how many attacks each domain performs better
    ll_wins = sum(metrics_ll(2:end, 1) > metrics_hh(2:end, 1));
    hh_wins = sum(metrics_hh(2:end, 1) > metrics_ll(2:end, 1));
    ties = sum(abs(metrics_ll(2:end, 1) - metrics_hh(2:end, 1)) < 0.01);
    
    % Create a summary table
    result = table;
    result.Domain = {'LL'; 'HH'};
    result.AvgPSNR = [ll_avg_psnr; hh_avg_psnr];
    result.AvgSSIM = [ll_avg_ssim; hh_avg_ssim];
    result.WinsAgainstAttacks = [ll_wins; hh_wins];
    
    % Add recommendation
    if ll_avg_psnr > hh_avg_psnr && ll_avg_ssim > hh_avg_ssim
        recommendation = 'LL domain appears more robust against attacks';
    elseif hh_avg_psnr > ll_avg_psnr && hh_avg_ssim > ll_avg_ssim
        recommendation = 'HH domain appears more robust against attacks';
    else
        if ll_wins > hh_wins
            recommendation = 'LL domain wins against more attack types';
        elseif hh_wins > ll_wins
            recommendation = 'HH domain wins against more attack types';
        else
            recommendation = 'Both domains show similar robustness';
        end
    end
    
    result.Properties.UserData = recommendation;
    result.Properties.Description = recommendation;
end

% Test the attack function on stego images
attackk('stego_image1.png', 'cover_image1.jpg');
attackk('stego_image2.png','cover_image2.jpg');
attackk('stego_image3.png','cover_image3.jpg');
attackk('stego_image4.png','cover_image4.jpg');

% Optionally, you can also test if the messages can still be extracted after attacks
% For example, to test extraction after JPEG compression:

% Apply JPEG compression to a stego image
temp_jpg = [tempname '.jpg'];
stego_img = imread('stego_image1.png');
imwrite(stego_img, temp_jpg, 'jpg', 'Quality', 80);
attacked_img = temp_jpg;

% Try to extract the message from the attacked image
% Uncomment this line to test extraction after attack
% extractt(attacked_img, 'cover_image1.jpg', length('Hello, World !!'));

% Clean up
delete(temp_jpg);