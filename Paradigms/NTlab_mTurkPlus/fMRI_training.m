function data = fMRI_training()
    clear Screen
    clear PsychSerial
    clear all
    sca
    
    global rectColor imgChTexPtr imgAChTexPtr window sampleRect ...
        imageRect colTexPtr choiceRects center
    global window2 sampleRect2 choiceRects2 center2 eyetraceRect
    global channels port gain Vcent Vcent2
    global responseTime juiceTime
    global Quit screenRect samplePos
    
    channels = [3 4]; %analog input
    port = 1; %digital output
    %have to set these after 5dot
    gain(1) =  -891; 
    gain(2) = 1140;
    Vcent = [0 0];
    Vcent2 = Vcent;
    fnDAQNI('Init',0);
    WaitSecs;
    
    backgroundRGB = [152, 132, 151];
    %must calibrate these
    cRED = [246, 142, 209, 121, 142, 81, 83, 48, 162, 93, 236, 136, 191, 110];
    cGREEN = [134, 77, 165, 96, 187, 108, 190, 109, 163, 94, 125, 73, 165, 94];
    cBLUE = [175, 97, 95, 52, 129, 71, 218, 120, 255, 153, 255, 142, 198, 109];
    
    %set these variables
    taskReps = 5; %how many times each task shows up in one sequence
    shapeReps = 10; %how many times each shape shows up in one sequence
    sampleTime = 1;
    responseTime = 0.2;
    responseTimeLimit = 10;
    juiceTime = 0.018;
    trialDelay = 0.5;
    punishTime = 1.5;
    
    %initialize output struct
    data.sample = [];
    data.correct = [];
    data.response = [];
    data.foils = [];
    data.task = [];

    whichScreen = 2;
    [window, screenRect] = Screen('OpenWindow', whichScreen, backgroundRGB, [], 32); 
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

    whichScreen2 = 1;
    [window2,screenRect2] = Screen('OpenWindow', whichScreen2, backgroundRGB, [0,0,1000,800], 32);
    Screen('BlendFunction', window2, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    %make textures for images and color circle
    [imgCh,imgACh,circle] = getImages();
    numShapes = 14;
    shapes = zeros(numShapes,1);
    for i = 1:numShapes
       shapes(i) = i; 
    end
    colTexPtr = Screen('MakeTexture',window, circle);
    imgChTexPtr = zeros(numShapes,1);
    imgAChTexPtr = zeros(numShapes,1);
    rectColor = zeros(numShapes,3);
    for i = 1:numShapes
        imgChTexPtr(i) = Screen('MakeTexture',window, imgCh{i});
        imgAChTexPtr(i) = Screen('MakeTexture',window, imgACh{i});
        rectColor(i,:) = [cRED(i) cGREEN(i) cBLUE(i)];
    end
    %rectangle that is the size of the original images
    [imgX,imgY,~] = size(imgCh{1});
    imageRect = [0 0 imgX imgY];
    
    dotSize = 4;
    eyetraceRect = [0 0 dotSize dotSize];

    %sets up rectangle for displaying colors
    %first screen
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    [center(1), center(2)] = RectCenter(screenRect);
    baseRect = [0 0 screenXpixels/8 screenXpixels/8];
    choiceCenters = getChoiceRects([screenXpixels,screenYpixels],center);
    choiceRects = CenterRectOnPointd(baseRect, choiceCenters(:,1),choiceCenters(:,2));
    sampleRect = CenterRectOnPointd(baseRect, center(1), center(2));
    
    %second screen
    [screenXpixels2, screenYpixels2] = Screen('WindowSize', window2);
    [center2(1), center2(2)] = RectCenter(screenRect2);
    baseRect2 = [0 0 screenXpixels2/8 screenXpixels2/8];
    choiceCenters2 = getChoiceRects([screenXpixels2,screenYpixels2],center2);
    choiceRects2 = CenterRectOnPointd(baseRect2, choiceCenters2(:,1),choiceCenters2(:,2));
    sampleRect2 = CenterRectOnPointd(baseRect2, center2(1), center2(2));
    
    %GUI for adjusting parameters
    f = figure('Visible', 'on','Position', [300 400 300 150]);
    recenterBtn = uicontrol('Position',[40 100 70 25],'String','Recenter');
    recenterBtn.Callback = @(src,event)recenter(center,center2);
    looktimeText = uicontrol('Style','text','Position',[270,30,25,12],...
        'String',num2str(responseTime),'BackgroundColor',f.Color);
    looktimeSlider = uicontrol('Style','slider','Position',[10 30 250 12],'value',responseTime,'min',0.01,'max',1); 
    looktimeSlider.Callback = @(es,ed) adjustLookTime(es,ed,looktimeText);
    juicetimeText = uicontrol('Style','text','Position',[270,15,25,12],...
        'String',num2str(juiceTime),'BackgroundColor',f.Color);
    juicetimeSlider = uicontrol('Style','slider','Position',[10 15 250 12],'value',juiceTime,'min',0.01,'max',0.1); 
    juicetimeSlider.Callback = @(es,ed) adjustJuiceTime(es,ed,juicetimeText);
    
    %point at center of screen to recenter before beginning
    centerPoint = CenterRectOnPointd(eyetraceRect,center(1),center(2));
    Screen('FillOval',window,[0,0,0],centerPoint);
    Screen('Flip',window);
    
    taskVer = input('enter task version');
    taskTypes = getTaskTypes(taskVer,taskReps);
    trialShapes = getTrialShapes(numShapes,shapeReps);
    taskSequence = taskTypes(randperm(length(taskTypes)));
    shapeSequence = trialShapes(randperm(length(trialShapes)));
    trialNum = 1;
    Quit = 0;
    
    while (~Quit)
        task = taskSequence(mod(trialNum,length(taskSequence)));
        sample = shapeSequence(mod(trialNum,length(shapeSequence)));
        foils = chooseFoils(shapes,sample);
        [testShapeGrid,samplePos] = arrangeTestShapes(sample,foils);
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyIsDown && keyCode(74) %j to juice
            deliverJuice(juiceTime); 
        end
        
        displaySample(sample,task,window,sampleRect);
        Screen('FrameRect',window2,[0,0,0],sampleRect2);
        Screen('Flip',window2);
        %WaitSecs(sampleTime);
        waitForTrial(responseTime);
        displayTestShapes(testShapeGrid,task,window,choiceRects);
        Screen('FrameRect',window2,[0,0,0],choiceRects2');
        Screen('FrameRect',window2,[255,200,0],choiceRects2(samplePos,:)');
        Screen('Flip',window2);
        response = waitForResponse(responseTime,responseTimeLimit);
        %response = waitForResponseTest(responseTimeLimit);

        if response == samplePos
            disp(1);
            Screen('Flip',window);
            deliverJuice(juiceTime);
            WaitSecs(trialDelay);
        else
            disp(0);
            Screen('Flip',window);
            WaitSecs(punishTime);
        end
        
        %shuffle shapes and trials after reaching end of a sequence
        if mod(trialNum,taskSequence) == 0
            taskSequence = taskTypes(randperm(length(taskTypes)));
        end
        if mod(trialNum,length(shapeSequence)) == 0
            shapeSequence = trialShapes(randperm(length(trialShapes)));
        end 
        data.sample = [data.sample; sample];
        data.correct = [data.correct; samplePos];
        data.response = [data.response; response];
        data.task = [data.task; task];
        data.foils = [data.foils; foils];
        trialNum = trialNum + 1;
    end
    sca;
end

function deliverJuice(juiceTime)
    global port
    fnDAQNI('SetBit',port,1);
    WaitSecs(juiceTime);
    fnDAQNI('SetBit',port,0);
end

function waitForTrial(responseTime)
    global window2 choiceRects2 eyetraceRect center2 Vcent2 juiceTime window screenRect
    global sampleRect2 Quit
    currentRect = -1;
    gazeStart = 0;
    while 1
        drawEyePos(window2,Vcent2,choiceRects2,sampleRect2,eyetraceRect,center2,1)
        eyePos = getEyePos();
        gazeRect = checkGazeRect(eyePos);
        if gazeRect == 0 && currentRect == 0
            if gazeStart - GetSecs > responseTime
                break;
            end
        else
            currentRect = gazeRect;
            gazeStart = GetSecs;
        end
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown && keyCode(53) %5 to manually move on
            break;
        end
        if keyIsDown && keyCode(74) %j to juice
            deliverJuice(juiceTime); 
        end
        if keyIsDown && keyCode(65) %a to grab attention
            grabAttention(window,screenRect,0.5);
        end
        if keyIsDown && keyCode(27)
            Quit = 1;
            break;
        end
    end
end

function response = waitForResponse(responseTime,timeLimit)
    global window window2 choiceRects2 eyetraceRect center2 Quit Vcent2 screenRect juiceTime
    global sampleRect2
    responseGiven = 0;
    startTime = GetSecs;
    gazeStart = 0;
    currentRect = -1;
    response = 0;
    
    while (~responseGiven)
        if GetSecs - startTime >= timeLimit
            response = 0;
            break;
        end
        drawEyePos(window2,Vcent2,choiceRects2,sampleRect2,eyetraceRect,center2,2)
        eyePos = getEyePos();
        gazeRect = checkGazeRect(eyePos);

        %if the monkey is still looking at the same choice, see if it's
        %looked at the choice for long enough. If it's looking at a
        %different choice, restart the timer
        if gazeRect == currentRect && gazeRect > 0
            if gazeStart - GetSecs > responseTime
                responseGiven = 1;
                response = currentRect;
            end
        else
            gazeStart = GetSecs;
            currentRect = gazeRect;
        end
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown && keyCode(49)
            response = 1;
            break;
        end
        if keyIsDown && keyCode(50)
            response = 2;
            break; 
        end
        if keyIsDown && keyCode(51)
            response = 3;
            break;
        end
        if keyIsDown && keyCode(52)
            response = 4;
            break;
        end
        if keyIsDown && keyCode(27)
            Quit = 1;
            break;
        end
        if keyIsDown && keyCode(74) %j to juice
            deliverJuice(juiceTime); 
        end
        if keyIsDown && keyCode(65) %a to grab attention
            grabAttention(window,screenRect,0.5);
        end
    end
end

function response = waitForResponseTest(timeLimit)
    global Quit
    response = 0;
    startTime = GetSecs;
    while GetSecs-startTime < timeLimit
        [keyIsDown, ~, keyCode] = KbCheck;
        if keyIsDown && keyCode(49)
            response = 1;
            break;
        end
        if keyIsDown && keyCode(50)
            response = 2;
            break; 
        end
        if keyIsDown && keyCode(51)
            response = 3;
            break;
        end
        if keyIsDown && keyCode(52)
            response = 4;
            break;
        end
        if keyIsDown && keyCode(27)
            Quit = 1;
            break;
        end
    end
end

function gazeRect = checkGazeRect(eyePos)
    global choiceRects sampleRect
    if eyePos(1) > choiceRects(1,1) && eyePos(1) < choiceRects(1,3) ...
            && eyePos(2) > choiceRects(1,2) && eyePos(2) < choiceRects(1,4)
        gazeRect = 1;
    elseif eyePos(1) > choiceRects(2,1) && eyePos(1) < choiceRects(2,3) ...
            && eyePos(2) > choiceRects(2,2) && eyePos(2) < choiceRects(2,4)
        gazeRect = 2;
    elseif eyePos(1) > choiceRects(3,1) && eyePos(1) < choiceRects(3,3) ...
        && eyePos(2) > choiceRects(3,2) && eyePos(2) < choiceRects(3,4)
        gazeRect = 3;
    elseif eyePos(1) > choiceRects(4,1) && eyePos(1) < choiceRects(4,3) ...
            && eyePos(2) > choiceRects(4,2) && eyePos(2) < choiceRects(4,4)
        gazeRect = 4;
    elseif eyePos(1) > sampleRect(1) && eyePos(1) < sampleRect(3) ...
            && eyePos(2) > sampleRect(2) && eyePos(2) < sampleRect(4)
        gazeRect = 0;
    else
        gazeRect = -1;
    end
end

function eyePos = getEyePos()
    global channels gain Vcent center
    Vraw = fnDAQNI('GetAnalog',channels);
    Xpos = (Vraw(1) - Vcent(1))*gain(1) + center(1);
    Ypos = (Vraw(2) - Vcent(2))*gain(2) + center(2);
    eyePos = [Xpos Ypos];
end

function drawEyePos(window,Vcent,choiceRects,sampleRect,eyeRect,screenCenter,stage)
    global channels gain samplePos
    Vraw = fnDAQNI('GetAnalog',channels);
    Xpos = (Vraw(1) - Vcent(1))*gain(1) + screenCenter(1);
    Ypos = (Vraw(2) - Vcent(2))*gain(2) + screenCenter(2);
    eyePosRect = CenterRectOnPointd(eyeRect,Xpos,Ypos);
    if stage == 2
       Screen('FrameRect',window,[0,0,0],choiceRects');
       Screen('FrameRect',window,[255,200,0],choiceRects(samplePos,:)');
    elseif stage == 1
       Screen('FrameRect',window,[0,0,0],sampleRect); 
    end
    Screen('FillOval',window,[0,0,0],eyePosRect);
    Screen('Flip',window);
end

function displaySample(sample,task,window,sampleRect)
    global rectColor imgChTexPtr imgAChTexPtr imageRect colTexPtr
    switch task
        case {1,2}
            Screen('FillRect',window,rectColor(sample,:),sampleRect);
            Screen('DrawTexture',window,imgChTexPtr(sample),imageRect,sampleRect);
            Screen('Flip',window);
        case {3,7}
            Screen('DrawTexture',window,imgAChTexPtr(sample),imageRect,sampleRect);
            Screen('Flip',window);
        case {4,6}
            Screen('FillRect',window,rectColor(sample,:),sampleRect);
            Screen('DrawTexture',window,colTexPtr,imageRect,sampleRect);
            Screen('Flip',window);
        case 5
            Screen('DrawTexture',window,imgChTexPtr(sample),imageRect,sampleRect);
            Screen('Flip',window);
    end
end

function displayTestShapes(testShapeGrid,task,window,choiceRects)
    global rectColor imgChTexPtr imgAChTexPtr imageRect colTexPtr
    switch task
        case {1,4,5}
            for i = 1:length(testShapeGrid)
                Screen('FillRect',window,rectColor(testShapeGrid(i),:),choiceRects(i,:));
                Screen('DrawTexture',window,colTexPtr,imageRect,choiceRects(i,:));
            end
            Screen('Flip',window);
        case {2,6}
            for i = 1:length(testShapeGrid)
                Screen('DrawTexture',window,imgChTexPtr(testShapeGrid(i),:),imageRect,choiceRects(i,:));
            end
            Screen('Flip',window);
        case {3,7}
            for i = 1:length(testShapeGrid)
                Screen('DrawTexture',window,imgAChTexPtr(testShapeGrid(i),:),imageRect,choiceRects(i,:));
            end
            Screen('Flip',window);
    end   
end

function [testShapeGrid,samplePos] = arrangeTestShapes(sample,foils)
    testShapeGrid = zeros(4,1);
    samplePos = ceil(rand()*4);
    foilCount = 1;
    for i = 1:4
       if i == samplePos
           testShapeGrid(i) = sample;
       else
           testShapeGrid(i) = foils(foilCount);
           foilCount = foilCount+1;
       end
    end
end

function recenter(center,center2)
    global gain Vcent Vcent2 channels
    gains = [gain(1) gain(2)];
    Vraw = fnDAQNI('GetAnalog',channels);
    Vcent = Vraw - (center - center) ./ gains;
    Vcent2 = Vraw - (center2 - center2) ./ gains;
end

function foils = chooseFoils(shapes,sample)
    foilChoices = shapes([1:sample-1,sample+1:end]);
    foilChoices = foilChoices(randperm(length(foilChoices)));
    foils = [foilChoices(1),foilChoices(2),foilChoices(3)];
end

function trialShapes = getTrialShapes(numShapes,numReps)
    trialShapes = ones(numShapes*numReps);
    for i = 1:numShapes
        startIdx = (i-1)*numReps + 1;
        stopIdx = i*numReps;
       trialShapes(startIdx:stopIdx) = trialShapes(startIdx:stopIdx)*i; 
    end
end

function taskTypes = getTaskTypes(taskVer,numReps)
    if taskVer == 3
        taskTypes = ones(numReps*4,1);
        taskTypes(numReps+1:numReps*2) = taskTypes(numReps+1:numReps*2)*2;
        taskTypes(numReps*2+1:numReps*3) = taskTypes(numReps*2+1:numReps*3)*3;
        taskTypes(numReps*3+1:numReps*4) = taskTypes(numReps*3+1:numReps*4)*4;
    else
        taskTypes = ones(numReps*3,1);
        taskTypes(1:numReps) = taskTypes(1:numReps)*5;
        taskTypes(numReps+1:numReps*2) = taskTypes(numReps+1:numReps*2)*6;
        taskTypes(numReps*2+1:numReps*3) = taskTypes(numReps*2+1:numReps*3)*7;
    end
end

function rectCenters = getChoiceRects(screenDims,center)
    upperLeftCentX = center(1) - screenDims(1) / 8;
    upperLeftCentY = center(2) - screenDims(1) / 8;
    upperRightCentX = center(1) + screenDims(1) / 8;
    upperRightCentY = center(2) - screenDims(1) / 8;
    lowerLeftCentX = center(1) - screenDims(1) / 8;
    lowerLeftCentY = center(2) + screenDims(1) / 8;
    lowerRightCentX = center(1) + screenDims(1) / 8;
    lowerRightCentY = center(2) + screenDims(1) / 8;
    rectCenters = [upperLeftCentX,upperLeftCentY; ...
               upperRightCentX,upperRightCentY; ...
               lowerLeftCentX,lowerLeftCentY; ...
               lowerRightCentX,lowerRightCentY];
end

function adjustLookTime(es,ed,looktimeText)
    global responseTime
    responseTime = es.Value;
    looktimeText.String = num2str(responseTime);
end

function adjustJuiceTime(es,ed,juicetimeText)
    global juiceTime
    juiceTime = es.Value;
    juicetimeText.String = num2str(juiceTime);
end

function grabAttention(window,windowRect,duration)
    ifi = Screen('GetFlipInterval', window);
    vbl = Screen('Flip', window);
    waitframes = 1;
    maxDotSize = 925;
    [xCenter, yCenter] = RectCenter(windowRect);
    amplitude = 1;
    frequency = 2;
    angFreq = 2 * pi * frequency;
    startPhase = 0;
    time = 0;
    while time < duration
       scaleFactor = abs(amplitude * sin(angFreq * time + startPhase));
       size = maxDotSize * scaleFactor;
       baseRect = [0 0 size size];
       dot = CenterRectOnPointd(baseRect,xCenter,yCenter);
       Screen('FillOval',window,[0 0 0],dot);
       Screen('Flip',window,vbl + (waitframes - 0.5) * ifi);
       time = time + ifi;
    end
end