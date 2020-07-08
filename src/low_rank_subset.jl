"""
Return (error, indices) for the subset of size n, whose k-rank approximation has lowest error, as measured by the 2-norm.
Checks all subsets of size n. Has comlpexity Ω(V^n).
"""
function find_low_rank_subset_checkall(data_set,n,k)
    f(S) = let M = hcat([data_set[i] for i in S]...);
        truncated_svd(M, k)[1], S end
    minimum(f , powerset(1:length(data_set), n, n) )
end

"""
Return (error, indices) for the subset of size n, whose k-rank approximation with vectors from data set has lowest error, as measured by the 2-norm.
Checks all subsets of size k. Has comlpexity Ω(V^k).
"""
function find_low_rank_subset_sample_rep(data_set,n,k)
    f(E) = let M = hcat([data_set[i] for i in E]...);
    M_times_pinv = M * pinv(M);
    distances_squared = [let d = v - M_times_pinv*v; dot(d,d) end for v in data_set]
    indices, distances = findmin(distances_squared, 1:n);
    sum(distances), indices
    end
    minimum(f, powerset(1:length(data_set), k, k))
end
