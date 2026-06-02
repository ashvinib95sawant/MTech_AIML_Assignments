% Decision rules for water source selection

% Rule 1: If lake distance is less than 10 km, use lake water immediately
water_source(LakeDistance, _, _, _, _, lake) :- 
    number(LakeDistance), LakeDistance < 10, !.

% Rule 2 (Prioritized): If river distance < 8, decide based on rainfall
water_source(_, RiverDistance, Rainfall, _, _, rain) :- 
    number(RiverDistance), RiverDistance < 8, number(Rainfall), Rainfall >= 200, !.

water_source(_, RiverDistance, Rainfall, _, _, river) :- 
    number(RiverDistance), RiverDistance < 8, number(Rainfall), Rainfall < 200, !.

% Rule 3: If rainfall is 150 mm/month or more, use rainwater
water_source(_, _, Rainfall, _, _, rain) :- 
    number(Rainfall), Rainfall >= 150, !.

% Rule 4: If aquifer is not present, check lake distance
water_source(LakeDistance, _, _, no, _, lake) :- 
    number(LakeDistance), LakeDistance < 14, !.

water_source(LakeDistance, _, _, no, _, rain) :- 
    number(LakeDistance), LakeDistance >= 14, !.

% Rule 5: If aquifer is present, check beach distance
water_source(_, RiverDistance, _, yes, BeachDistance, river) :- 
    number(RiverDistance), number(BeachDistance),
    BeachDistance < 5, RiverDistance < 20, !.

water_source(_, RiverDistance, _, yes, BeachDistance, rain) :- 
    number(RiverDistance), number(BeachDistance),
    BeachDistance < 5, RiverDistance >= 20, !.

water_source(_, _, _, yes, BeachDistance, groundwater) :- 
    number(BeachDistance), BeachDistance >= 5, !.

% User Input Handling
start :-  
    % Step 1: Get Lake Distance
    write('Enter Lake Distance (in km): '), read(LakeDistance),
    (   LakeDistance < 10 ->
        write('Recommended Water Source: lake'), nl
    ;
        % Step 2: Get River Distance and Rainfall
        write('Enter River Distance (in km): '), read(RiverDistance),
        write('Enter Rainfall Intensity (mm/month): '), read(Rainfall),

        % Step 3: Check river distance and rainfall first (as per new logic)
        (   RiverDistance < 8 ->
            (   Rainfall >= 200 ->
                write('Recommended Water Source: rain'), nl
            ;
                write('Recommended Water Source: river'), nl
            )
        ;
            % Step 4: If rainfall ≥ 150, prefer rain
            (   Rainfall >= 150 ->
                write('Recommended Water Source: rain'), nl
            ;
                % Step 5: Ask for Aquifer
                write('Is there a Sandy Aquifer? (yes/no): '), read(Aquifer),

                % Step 6: Aquifer-based decision
                (   Aquifer == yes ->
                    write('Enter Beach Distance (in km): '), read(BeachDistance),
                    water_source(LakeDistance, RiverDistance, Rainfall, yes, BeachDistance, WaterSource)
                ;
                    water_source(LakeDistance, RiverDistance, Rainfall, no, _, WaterSource)
                ),
                write('Recommended Water Source: '), write(WaterSource), nl
            )
        )
    ).
