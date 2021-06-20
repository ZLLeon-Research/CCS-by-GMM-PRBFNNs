function [pGamma] = gmm_te(X, Gmodel)
% ============================================================
% Expectation-Maximization iteration implementation of
% Gaussian Mixture Model.
%
% PX = GMM(X, K_OR_CENTROIDS)
% [PX MODEL] = GMM(X, K_OR_CENTROIDS)
%
%  - X: N-by-D data matrix.
%  - K_OR_CENTROIDS: either K indicating the number of
%       components or a K-by-D matrix indicating the
%       choosing of the initial K centroids.
%
%  - PX: N-by-K matrix indicating the probability of each
%       component generating each point.
%  - MODEL: a structure containing the parameters for a GMM:
%       MODEL.Miu: a K-by-D matrix.
%       MODEL.Sigma: a D-by-D-by-K matrix.
%       MODEL.Pi: a 1-by-K vector.
% ============================================================

    
    [N, D] = size(X);
    centroids = Gmodel.Miu;
    pMiu = Gmodel.Miu;
    pPi = Gmodel.Pi;
    pSigma = Gmodel.Sigma;
    K = size(centroids,1);
    
    Px = calc_prob();
    pGamma = Px .* repmat(pPi, N, 1);
    pGamma = pGamma ./ repmat(sum(pGamma, 2), 1, K);  %存储每个样本对各类的隶属度
    
    pGamma(find(pGamma<1e-3)) = 0; 
    
    function Px = calc_prob()
        Px = zeros(N, K);
        for k = 1:K
            Xshift = X-repmat(pMiu(k, : ), N, 1);%x-u
            lemda=1e-5;
            conv=pSigma(:, :, k)+lemda*diag(diag(ones(D)));
            inv_pSigma = inv(conv);
            tmp = sum((Xshift*inv_pSigma) .* Xshift, 2);%(X-U_k)sigma.*(X-U_k)
            coef = (2*pi)^(-D/2) * sqrt(det(inv_pSigma));
            Px(:, k) = coef * exp(-0.5*tmp);
        end
    end
end
