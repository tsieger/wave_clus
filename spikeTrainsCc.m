function spikeTrainsCc(times,classes)
    binSize=1;
    timeSpan=100;
    smoothOrder=10;

    function plotCc(x1,x2,maxLag,zeroLag0)
        minT=0;
        maxT=ceil(max(max(x1),max(x2)));
        maxT=binSize*ceil(maxT/binSize);
        bins=linspace(minT,maxT,(maxT-minT)/binSize+1);
        xb1=hist(x1,bins);
        xb2=hist(x2,bins);
        [xc,lags]=xcorr(xb1,xb2,timeSpan/binSize);
        if zeroLag0
            xc((length(xc)+1)/2)=0;
        end

        plot(lags*binSize/1000,xc);
        xlabel('time shift [s]');
        hold on
        xcs=filtfilt(boxcar(smoothOrder)/smoothOrder,1,xc);
        plot(lags*binSize/1000,xcs,'r','LineWidth',2);
        xbp1=xb1(randperm(length(xb1)));
        xbp2=xb2(randperm(length(xb2)));
        [xcp,lagsp]=xcorr(xbp1,xbp2,timeSpan/binSize);
        xcps=filtfilt(boxcar(smoothOrder)/smoothOrder,1,xcp);
        plot(lagsp*binSize/1000,xcps,'k:','LineWidth',2);
    end

    %x1=a.cluster_class(a.cluster_class(:,1)==1,2);
    %x2=a.cluster_class(a.cluster_class(:,1)==2,2);
    uniqueClasses=unique(classes);
    nUniqueClasses=length(uniqueClasses);
    if nUniqueClasses>0
        figure(11);
        clf();
        for i1=1:nUniqueClasses
            c1=uniqueClasses(i1);
            x1=times(classes==c1);
            for i2=i1:nUniqueClasses
                c2=uniqueClasses(i2);
                x2=times(classes==c2);

                subplot(nUniqueClasses,nUniqueClasses,(nUniqueClasses)*(i1-1)+i2);
                plotCc(x1,x2,timeSpan/binSize,i1==i2);
                title([num2str(c1) ' vs. ' num2str(c2)]);
            end
        end
    end
end
