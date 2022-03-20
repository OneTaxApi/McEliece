% McEliece Demo Hamming

% Octave implemenation
% Code modified from
%   http://www-math.ucdenver.edu/~wcherowi/courses/m5410/ctcmcel.html
%   https://stackoverflow.com/questions/42274010/mceliece-encryption-decryption-algorithm

% Further references
%   https://www.avoggu.com/posts/an-efficient-algorithm-for-hamming-(74)-decoding-matlab-implementation/
%   https://www.tutorialspoint.com/hamming-code-for-single-error-correction-double-error-detection


% Example using a Hamming Code rather than a Goppa Code
n=7;
%% Individual message size
k=4;
%% Generator Matrix
G = [1,0,0,0,1,1,0;...
     0,1,0,0,1,0,1;...
     0,0,1,0,0,1,1;...
     0,0,0,1,1,1,1;];
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
error = [0,0,0,0,1,0,0];

%% encrypted message 
encrypted_message = mod(message*Gprime + error,2)
% Decryption
emprime = encrypted_message/P;
%% Ordinarily error vector would be obtained from the message and
%% the private information
ee = error/P;
xSG = mod(emprime-ee,2);
xS = xSG(1:k)
decrypted_message = mod(xS/S,2)
