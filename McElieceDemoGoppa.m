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
%   https://en.wikipedia.org/wiki/Parity-check_matrix
%   http://www-math.ucdenver.edu/~wcherowi/courses/m5410/mcleice.pdf
%   https://github.com/jkrauze/mceliece
%   https://github.com/Colfenor/classic-mceliece-rust
%   https://github.com/gwafotapa/McEliece
%   https://github.com/pmassolino/hw-goppa-mceliece

% Example 2 using a Goppa Code
n = 12;
% Individual message size
k = 4;
% Maximum number of errors
t = 2;
%% A Binary Goppa code generator matrix
G = [1, 0, 0, 0, 0, 1, 1, 0, 1, 0, 1, 0; ...
     0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1; ...
     0, 0, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0; ...
     0, 0, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1;];
% Parity check
H = [0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0;...
     1, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 0;...
     1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0;...
     0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0;...
     1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0;...
     0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0;...
     1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0;...
     0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1;];
     
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
% Generate lookup tables for bitflip locations
iloc=zeros(1,255);
jloc=zeros(1,255);
for i=1:n
  for j=i:n
  error = [0,0,0,0,0,0,0,0,0,0,0,0];
  error(i) = 1;
  if i != j
    error(j) = 1;
  endif
  encrypted_message = mod(message*S*G + error,2);
  find_error = mod(encrypted_message*H',2);
  error_indicator = (find_error(1))*1 + ...
                  (find_error(2))*2 + ...
                  (find_error(3))*4 + ...
                  (find_error(4))*8 + ...
                  (find_error(5))*16 + ...
                  (find_error(6))*32 + ...
                  (find_error(7))*64 + ...
                  (find_error(8))*128;
  iloc(error_indicator)=i;
  if i != j
    jloc(error_indicator)=j;
  endif
 endfor
endfor

% Random eror vector
if rand > (1.0/13.0)
  error = [1,1,0,0,0,0,0,0,0,0,0,0] (1,randperm(n));
else
  error = [1,0,0,0,0,0,0,0,0,0,0,0] (1,randperm(n));
end
%% cipher text
encrypted_message = mod(message*Gprime + error,2)
%% Message Recovery
% Undo permutation
encrypted_message = mod(encrypted_message/P,2);
% Remove the error
find_error = mod(encrypted_message*H',2);
error_indicator = (find_error(1))*1 + ...
                  (find_error(2))*2 + ...
                  (find_error(3))*4 + ...
                  (find_error(4))*8 + ...
                  (find_error(5))*16 + ...
                  (find_error(6))*32 + ...
                  (find_error(7))*64 + ...
                  (find_error(8))*128;

if error_indicator > 0                  
  encrypted_message(iloc(error_indicator)) +=1;
  if jloc(error_indicator) > 0
    encrypted_message(jloc(error_indicator)) +=1;
  endif
endif
xSG = mod(encrypted_message,2);
% Due to ordering of columns in G message is in first k columns
xS = xSG(1:k);
decrypted_message = mod(round(xS/S),2)
