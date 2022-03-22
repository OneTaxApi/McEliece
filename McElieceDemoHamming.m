% McEliece Demo Hamming

% Octave implemenation
% Code modified from
%   http://www-math.ucdenver.edu/~wcherowi/courses/m5410/ctcmcel.html
%   https://stackoverflow.com/questions/42274010/mceliece-encryption-decryption-algorithm

% Further references
%   https://www.avoggu.com/posts/an-efficient-algorithm-for-hamming-(74)-decoding-matlab-implementation/
%   https://www.tutorialspoint.com/hamming-code-for-single-error-correction-double-error-detection
%   https://en.wikipedia.org/wiki/Hamming(7,4)

% Example using a Hamming Code rather than a Goppa Code
n=7;
%% Individual message size
k=4;
%% Generator Matrix
    %d1 d2 d3 d4 p1 p2 p3 
G = [ 1, 0, 0, 0, 1, 1, 0;... %d1
      0, 1, 0, 0, 1, 0, 1;... %d2
      0, 0, 1, 0, 0, 1, 1;... %d3
      0, 0, 0, 1, 1, 1, 1;];  %d4
%% Parity check
    %d1 d2 d3 d4 p1 p2 p3
H = [ 1, 1, 0, 1, 1, 0, 0;  %p1
      1, 0, 1, 1, 0, 1, 0;  %p2
      0, 1, 1, 1, 0, 0, 1;];%p3 
%% An invertible scrambler binary random matrix 
S=zeros(k);
while ( abs(cond(S)) > 10 )  
  S = rand(k) > 0.5;
endwhile
%% A random permutation matrix
P = eye(n) (:,randperm(n));

%% Public key
Gprime = mod(S*G*P,2);

%% message
message = [1,1,0,1]
%% error vector
error = [1,0,0,0,0,0,0]  (1,randperm(n));

%% encrypted message 
encrypted_message = mod(message*Gprime + error,2)

% Decryption
% Undo permutation
encrypted_message = mod(encrypted_message/P,2);
% Remove error
find_error = mod(H*encrypted_message',2);
%% Use a lookup table bit to flip
error_position_table=[5,6,1,7,2,3,4];
error_indicator = (find_error(1))*1 + ...
                  (find_error(2))*2 + ...
                  (find_error(3))*4;
if error_indicator > 0                  
  encrypted_message(error_position_table(error_indicator)) +=1;
endif
xSG = mod(encrypted_message,2);
% Due to ordering of columns in G message is in first k columns
xS = xSG(1:k);
decrypted_message = mod(round(xS/S),2)
