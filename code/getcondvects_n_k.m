function [condvects] = getcondvects_n_k(n,k,val_Vector,dtype,filename)
arguments
    n double
    k double = size(n,1)
    val_Vector cell = {0:n-1}
    dtype string = "double"
    filename string = "none"
end
%     if isempty(n)
%         for l=1:size(val_Vector,1)
%             n(l,1)=length(val_Vector{l});
%         end
%     end
    n=n(:);
    if size(n,1)==1
        n=repmat(n,[k,1]);
        rows=prod(n);
    elseif size(n,1)==k
        rows = prod(n);
    else
        fprintf("Check n and k values.\n n should have as many rows as value of k\n")
    end
    if nargin == 2
        val_Vector = cell(length(n),1);
        for l=1:length(n)
            val_Vector{l} = 0:n(l)-1;
        end
    end
    if nargin > 2 && ~sum(length(val_Vector)==length(n))==k
        fprintf("Defaulting val_vector\n Check length of val_vector\n")
        val_Vector = cell(length(n),1);
        for l=1:k
            val_Vector{l} = 0:n(l)-1;
        end
    end
    if nargin>2 && size(val_Vector,1)==1
        vals=val_Vector;
        val_Vector = cell(length(n),1);
        for l=1:k
            val_Vector{l} = vals;
        end
    end
    if nargin < 4
        dtype='double';
    end
    if ~isequal('cell',dtype)
        condvects=zeros(rows,k);
        for i =1:k
            condvects(:,end+1-i)=reshape(repmat(val_Vector{i},prod(n)/prod(n(i:end)),prod(n)/prod(n(1:i))),[rows,1]);
        end
    elseif isequal("cell",dtype)
        condvects=cell(rows,1);
        condvects_n_k_temp=zeros(rows,k);
        for i =1:k
            condvects_n_k_temp(:,end+1-i)=reshape(repmat(val_Vector{i},prod(n)/prod(n(i:end)),prod(n)/prod(n(1:i))),[rows,1]);
        end
        for j=1:rows
            condvects{j}=condvects_n_k_temp(j,:);
        end
    end
    if nargin == 5
        filename=[filename,'.xlsx'];
        writematrix(condvects,filename)
    end
end