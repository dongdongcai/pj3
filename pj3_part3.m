for i = 1:10
    word=sprintf('fold %0.0d. \n ',i);
    disp(word);
    temp = test{i};
    testpart = [];
    for j = 1:10000
        testpart = [testpart ;{u(temp(j), 1), u(temp(j), 2)}];
    end
    [error, predict] = factofor10fold(R,100,testpart); % you can change k here
    pointer = 1;
    thre = 0:0.01:5;
    precision = zeros(1, length(thre));
    recall = zeros(1, length(thre));
    for k = 1:length(thre)
        precisionpre = 0;
        precisionact = 0;
        recallact = 0;
        recallpre = 0;
        for j = 1:10000
            user = testpart{j, 1};
            movie = testpart{j, 2};
            %if predict(user, movie) > thre(k)
            %    precisionpre = precisionpre + 1;
            %    if R(user, movie) > thre(k)
            %        precisionact = precisionact + 1;
            %    end
            %end
            if R(user, movie) > thre(k)
                precisionpre = precisionpre + 1;
                if predict(user, movie) > thre(k)
                    precisionact = precisionact + 1;
                end
            end            
            if R(user, movie) <= thre(k) && R(user, movie) > 0
                recallact = recallact + 1;
                if predict(user, movie) > thre(k)
                    recallpre = recallpre + 1;
                end
            end
        end
        precision(pointer) = precisionact / precisionpre;
        recall(pointer) = recallpre / recallact;
        pointer = pointer + 1;
    end
    hold on
    plot(recall, precision, '+');
    xlabel('recall');
    ylabel('precision');
    title('ROC curve with different threshold');
end