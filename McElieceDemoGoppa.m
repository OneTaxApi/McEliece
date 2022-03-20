% McEliece Demo

% Octave implemenation

% Ashley Valentin "Goppa Codes and their use in McEliece Cryptosystems" 1 May 2015
% https://surface.syr.edu/cgi/viewcontent.cgi?article=1846&context=honors_capstone

% Code modified from
%   http://www-math.ucdenver.edu/~wcherowi/courses/m5410/ctcmcel.html
%   https://stackoverflow.com/questions/42274010/mceliece-encryption-decryption-algorithm

% Further references:
%   http://www-math.ucdenver.edu/~wcherowi/courses/m5410/ctcmcel.html
%   https://stackoverflow.com/questions/42274010/mceliece-encryption-decryption-algorithm

% Example 2 using a Goppa Code
n = 12;
% Individual message size
k = 4;
%% A Binary Goppa code generator matrix
G = [0, 1, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0; ...
     0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0; ...
     1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1; ...
     1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 1, 0;];

%% An invertible scrambler binary random matrix 
S=zeros(k);
while ( abs(cond(S)) > 10 )  
  S = rand(k) > 0.5;
endwhile
%% A random permutation matrix

P = eye(n) (:,randperm(n));
%% Public key
Gprime = mod(S*G*P,2); 
%% Message
message = [1,0,1,0]
%% random error vector
error = [1,1,0,0,0,0,0,0,0,0,0,0];
%% cipher text
encrypted_message = mod(message*Gprime + error,2)
%% Message Recovery
emprime = mod(encrypted_message/P,2);
%% Ordinarily error vector would be obtained from the message and
%% the private information, the Goppa code
mSG = mod(emprime - mod(error/P,2),2);
mSGGt = mSG*G';
GGt=G*G';
msrecovered = mSGGt*pinv(GGt);
decrypted_message = mod(round(msrecovered*pinv(S)),2)
