function spikeTrainsPsd(times,classes)
    binSize=5;

    function plotPsd(x1)
        minT=0;
        maxT=ceil(max(x1));
        maxT=binSize*ceil(maxT/binSize);
        bins=linspace(minT,maxT,(maxT-minT)/binSize+1);
        xb1=hist(x1,bins);
        N=300;
        fs=1/(binSize/1000);
        psd(xb1,N,fs,hamming(N),fix(.6*N));
    end

    uniqueClasses=unique(classes);
    nUniqueClasses=length(uniqueClasses);
    if nUniqueClasses>0
        figure(12);
        clf();
        for i1=1:nUniqueClasses
            c1=uniqueClasses(i1);
            x1=times(classes==c1);
            subplot(nUniqueClasses,nUniqueClasses,(nUniqueClasses)*(i1-1)+i1);
            plotPsd(x1);
            title(['PSD of ',num2str(c1)]);

        end
    end
end
