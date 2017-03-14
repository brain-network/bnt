function [ accesTimesMatrix ] = accesstime( Gtest )
%ACCESSTIME Estimate the access time matrix.
% 	H = ACCESSTIME(G) estimates the access time matrix H(i,j) from
% 	a connectivity matrix G. G is a symmetric connectivity matrix with
% 	non-negative entries (tested on real variables). H is the access time
% 	matrix H(i,j) such as described in the reference.
%
%   Reference:
%       Chavez M, De Vico Fallani F, Valencia M, Artieda J, Mattia D,
%       Latora V and Babiloni F (2013). "Node accessibility in cortical
%       networks during motor tasks". Neuroinformatics.
%
%   Mario Chavez, Fabrizio De Vico Fallani & Miguel Valencia 2013

Units = size(Gtest,1);
Gij = full(Gtest);
sumGij = sum(Gij);
degree = sum(Gij,2);
Lt= diag(sumGij.^(-1))*Gij;
Ln = diag(sumGij.^(1/2))*Lt*diag(sumGij.^(-1/2));
Ln = (Ln+Ln')/2; %to avoid round-offf errors
[accesTimesMatrix] = accesTimeMatrixFromPij(Ln,degree);
return

function [h] = accesTimeMatrixFromPij(L,degree)
Units = size(L,1);
[V,LAMl]=eig(full(L));
LAMBDAs = diag(LAMl);
[LAMBDAs, indexLAMBDAs] = sort(LAMBDAs,'descend');
V = V(:,indexLAMBDAs);

h = zeros(Units,Units);
for ii=1:Units
    d_i = degree(ii); 
    %tmp2 = 0;    
    for jj=1:Units
        d_j = degree(jj); 
        if (d_i == 0 || d_j ==0)
            h(i,j) = Inf;
            h(j,i) = Inf;
        else
            tmp1 = 0;
            for k=2:Units %lambda_1=1
                eigenvalue = LAMBDAs(k);
                tmp1 = tmp1 + (1/(1-eigenvalue)) * (V(ii,k)*V(ii,k)/d_i - V(jj,k)*V(ii,k)/sqrt(d_i)/sqrt(d_j));
            end
            %tmp2 = tmp2 +tmp1*d_j/(sum(degree));
            h(ii,jj) = tmp1;
        end
    end %for jj
    %hjjj(ii) = tmp2;
end %for ii
h = sum(degree)*h;
return