{-# OPTIONS_GHC -w #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Parser (
  parseExpr,
  parseTokens,
) where

import Lexer
import Syntax

import Control.Monad.Except
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.5

data HappyAbsSyn t4 t5 t6 t7 t8 t9 t10
	= HappyTerminal (Token)
	| HappyErrorToken Int
	| HappyAbsSyn4 t4
	| HappyAbsSyn5 t5
	| HappyAbsSyn6 t6
	| HappyAbsSyn7 t7
	| HappyAbsSyn8 t8
	| HappyAbsSyn9 t9
	| HappyAbsSyn10 t10

action_0 (12) = happyShift action_4
action_0 (13) = happyShift action_5
action_0 (14) = happyShift action_6
action_0 (15) = happyShift action_7
action_0 (16) = happyShift action_8
action_0 (17) = happyShift action_9
action_0 (18) = happyShift action_10
action_0 (27) = happyShift action_2
action_0 (4) = happyGoto action_3
action_0 _ = happyFail

action_1 (27) = happyShift action_2
action_1 _ = happyFail

action_2 (27) = happyShift action_12
action_2 (28) = happyShift action_13
action_2 (29) = happyShift action_14
action_2 (33) = happyShift action_15
action_2 (34) = happyShift action_16
action_2 (35) = happyShift action_17
action_2 (42) = happyShift action_18
action_2 (55) = happyShift action_19
action_2 (58) = happyShift action_20
action_2 (10) = happyGoto action_26
action_2 _ = happyFail

action_3 (59) = happyAccept
action_3 _ = happyFail

action_4 (27) = happyShift action_12
action_4 (28) = happyShift action_13
action_4 (29) = happyShift action_14
action_4 (33) = happyShift action_15
action_4 (34) = happyShift action_16
action_4 (35) = happyShift action_17
action_4 (42) = happyShift action_18
action_4 (55) = happyShift action_19
action_4 (58) = happyShift action_20
action_4 (10) = happyGoto action_25
action_4 _ = happyFail

action_5 (58) = happyShift action_24
action_5 _ = happyFail

action_6 (27) = happyShift action_12
action_6 (28) = happyShift action_13
action_6 (29) = happyShift action_14
action_6 (33) = happyShift action_15
action_6 (34) = happyShift action_16
action_6 (35) = happyShift action_17
action_6 (42) = happyShift action_18
action_6 (55) = happyShift action_19
action_6 (58) = happyShift action_20
action_6 (10) = happyGoto action_23
action_6 _ = happyFail

action_7 (27) = happyShift action_12
action_7 (28) = happyShift action_13
action_7 (29) = happyShift action_14
action_7 (33) = happyShift action_15
action_7 (34) = happyShift action_16
action_7 (35) = happyShift action_17
action_7 (42) = happyShift action_18
action_7 (55) = happyShift action_19
action_7 (58) = happyShift action_20
action_7 (10) = happyGoto action_22
action_7 _ = happyFail

action_8 _ = happyReduce_5

action_9 (27) = happyShift action_12
action_9 (28) = happyShift action_13
action_9 (29) = happyShift action_14
action_9 (33) = happyShift action_15
action_9 (34) = happyShift action_16
action_9 (35) = happyShift action_17
action_9 (42) = happyShift action_18
action_9 (55) = happyShift action_19
action_9 (58) = happyShift action_20
action_9 (10) = happyGoto action_21
action_9 _ = happyFail

action_10 (27) = happyShift action_12
action_10 (28) = happyShift action_13
action_10 (29) = happyShift action_14
action_10 (33) = happyShift action_15
action_10 (34) = happyShift action_16
action_10 (35) = happyShift action_17
action_10 (42) = happyShift action_18
action_10 (55) = happyShift action_19
action_10 (58) = happyShift action_20
action_10 (10) = happyGoto action_11
action_10 _ = happyFail

action_11 (23) = happyShift action_67
action_11 (28) = happyShift action_28
action_11 (29) = happyShift action_29
action_11 (30) = happyShift action_30
action_11 (31) = happyShift action_31
action_11 (32) = happyShift action_32
action_11 (36) = happyShift action_33
action_11 (37) = happyShift action_34
action_11 (38) = happyShift action_35
action_11 (39) = happyShift action_36
action_11 (40) = happyShift action_37
action_11 (41) = happyShift action_38
action_11 (43) = happyShift action_39
action_11 (44) = happyShift action_40
action_11 (45) = happyShift action_41
action_11 (46) = happyShift action_42
action_11 (47) = happyShift action_43
action_11 (48) = happyShift action_44
action_11 (49) = happyShift action_45
action_11 (50) = happyShift action_46
action_11 (51) = happyShift action_47
action_11 (52) = happyShift action_48
action_11 (53) = happyShift action_49
action_11 (54) = happyShift action_50
action_11 _ = happyFail

action_12 (27) = happyShift action_12
action_12 (28) = happyShift action_13
action_12 (29) = happyShift action_14
action_12 (33) = happyShift action_15
action_12 (34) = happyShift action_16
action_12 (35) = happyShift action_17
action_12 (42) = happyShift action_18
action_12 (55) = happyShift action_19
action_12 (58) = happyShift action_20
action_12 (10) = happyGoto action_66
action_12 _ = happyFail

action_13 (27) = happyShift action_12
action_13 (28) = happyShift action_13
action_13 (29) = happyShift action_14
action_13 (33) = happyShift action_15
action_13 (34) = happyShift action_16
action_13 (35) = happyShift action_17
action_13 (42) = happyShift action_18
action_13 (55) = happyShift action_19
action_13 (58) = happyShift action_20
action_13 (10) = happyGoto action_65
action_13 _ = happyFail

action_14 (27) = happyShift action_12
action_14 (28) = happyShift action_13
action_14 (29) = happyShift action_14
action_14 (33) = happyShift action_15
action_14 (34) = happyShift action_16
action_14 (35) = happyShift action_17
action_14 (42) = happyShift action_18
action_14 (55) = happyShift action_19
action_14 (58) = happyShift action_20
action_14 (10) = happyGoto action_64
action_14 _ = happyFail

action_15 (27) = happyShift action_12
action_15 (28) = happyShift action_13
action_15 (29) = happyShift action_14
action_15 (33) = happyShift action_15
action_15 (34) = happyShift action_16
action_15 (35) = happyShift action_17
action_15 (42) = happyShift action_18
action_15 (55) = happyShift action_19
action_15 (58) = happyShift action_20
action_15 (10) = happyGoto action_63
action_15 _ = happyFail

action_16 (27) = happyShift action_12
action_16 (28) = happyShift action_13
action_16 (29) = happyShift action_14
action_16 (33) = happyShift action_15
action_16 (34) = happyShift action_16
action_16 (35) = happyShift action_17
action_16 (42) = happyShift action_18
action_16 (55) = happyShift action_19
action_16 (58) = happyShift action_20
action_16 (10) = happyGoto action_62
action_16 _ = happyFail

action_17 (27) = happyShift action_12
action_17 (28) = happyShift action_13
action_17 (29) = happyShift action_14
action_17 (33) = happyShift action_15
action_17 (34) = happyShift action_16
action_17 (35) = happyShift action_17
action_17 (42) = happyShift action_18
action_17 (55) = happyShift action_19
action_17 (58) = happyShift action_20
action_17 (10) = happyGoto action_61
action_17 _ = happyFail

action_18 (27) = happyShift action_12
action_18 (28) = happyShift action_13
action_18 (29) = happyShift action_14
action_18 (33) = happyShift action_15
action_18 (34) = happyShift action_16
action_18 (35) = happyShift action_17
action_18 (42) = happyShift action_18
action_18 (55) = happyShift action_19
action_18 (58) = happyShift action_20
action_18 (10) = happyGoto action_60
action_18 _ = happyFail

action_19 (27) = happyShift action_12
action_19 (28) = happyShift action_13
action_19 (29) = happyShift action_14
action_19 (33) = happyShift action_15
action_19 (34) = happyShift action_16
action_19 (35) = happyShift action_17
action_19 (42) = happyShift action_18
action_19 (55) = happyShift action_19
action_19 (58) = happyShift action_20
action_19 (10) = happyGoto action_59
action_19 _ = happyFail

action_20 _ = happyReduce_54

action_21 (22) = happyShift action_57
action_21 (23) = happyShift action_58
action_21 (28) = happyShift action_28
action_21 (29) = happyShift action_29
action_21 (30) = happyShift action_30
action_21 (31) = happyShift action_31
action_21 (32) = happyShift action_32
action_21 (36) = happyShift action_33
action_21 (37) = happyShift action_34
action_21 (38) = happyShift action_35
action_21 (39) = happyShift action_36
action_21 (40) = happyShift action_37
action_21 (41) = happyShift action_38
action_21 (43) = happyShift action_39
action_21 (44) = happyShift action_40
action_21 (45) = happyShift action_41
action_21 (46) = happyShift action_42
action_21 (47) = happyShift action_43
action_21 (48) = happyShift action_44
action_21 (49) = happyShift action_45
action_21 (50) = happyShift action_46
action_21 (51) = happyShift action_47
action_21 (52) = happyShift action_48
action_21 (53) = happyShift action_49
action_21 (54) = happyShift action_50
action_21 _ = happyFail

action_22 (22) = happyShift action_55
action_22 (23) = happyShift action_56
action_22 (28) = happyShift action_28
action_22 (29) = happyShift action_29
action_22 (30) = happyShift action_30
action_22 (31) = happyShift action_31
action_22 (32) = happyShift action_32
action_22 (36) = happyShift action_33
action_22 (37) = happyShift action_34
action_22 (38) = happyShift action_35
action_22 (39) = happyShift action_36
action_22 (40) = happyShift action_37
action_22 (41) = happyShift action_38
action_22 (43) = happyShift action_39
action_22 (44) = happyShift action_40
action_22 (45) = happyShift action_41
action_22 (46) = happyShift action_42
action_22 (47) = happyShift action_43
action_22 (48) = happyShift action_44
action_22 (49) = happyShift action_45
action_22 (50) = happyShift action_46
action_22 (51) = happyShift action_47
action_22 (52) = happyShift action_48
action_22 (53) = happyShift action_49
action_22 (54) = happyShift action_50
action_22 (5) = happyGoto action_54
action_22 _ = happyFail

action_23 (26) = happyShift action_53
action_23 (28) = happyShift action_28
action_23 (29) = happyShift action_29
action_23 (30) = happyShift action_30
action_23 (31) = happyShift action_31
action_23 (32) = happyShift action_32
action_23 (36) = happyShift action_33
action_23 (37) = happyShift action_34
action_23 (38) = happyShift action_35
action_23 (39) = happyShift action_36
action_23 (40) = happyShift action_37
action_23 (41) = happyShift action_38
action_23 (43) = happyShift action_39
action_23 (44) = happyShift action_40
action_23 (45) = happyShift action_41
action_23 (46) = happyShift action_42
action_23 (47) = happyShift action_43
action_23 (48) = happyShift action_44
action_23 (49) = happyShift action_45
action_23 (50) = happyShift action_46
action_23 (51) = happyShift action_47
action_23 (52) = happyShift action_48
action_23 (53) = happyShift action_49
action_23 (54) = happyShift action_50
action_23 _ = happyFail

action_24 (26) = happyShift action_52
action_24 _ = happyFail

action_25 (26) = happyShift action_51
action_25 (28) = happyShift action_28
action_25 (29) = happyShift action_29
action_25 (30) = happyShift action_30
action_25 (31) = happyShift action_31
action_25 (32) = happyShift action_32
action_25 (36) = happyShift action_33
action_25 (37) = happyShift action_34
action_25 (38) = happyShift action_35
action_25 (39) = happyShift action_36
action_25 (40) = happyShift action_37
action_25 (41) = happyShift action_38
action_25 (43) = happyShift action_39
action_25 (44) = happyShift action_40
action_25 (45) = happyShift action_41
action_25 (46) = happyShift action_42
action_25 (47) = happyShift action_43
action_25 (48) = happyShift action_44
action_25 (49) = happyShift action_45
action_25 (50) = happyShift action_46
action_25 (51) = happyShift action_47
action_25 (52) = happyShift action_48
action_25 (53) = happyShift action_49
action_25 (54) = happyShift action_50
action_25 _ = happyFail

action_26 (11) = happyShift action_27
action_26 (28) = happyShift action_28
action_26 (29) = happyShift action_29
action_26 (30) = happyShift action_30
action_26 (31) = happyShift action_31
action_26 (32) = happyShift action_32
action_26 (36) = happyShift action_33
action_26 (37) = happyShift action_34
action_26 (38) = happyShift action_35
action_26 (39) = happyShift action_36
action_26 (40) = happyShift action_37
action_26 (41) = happyShift action_38
action_26 (43) = happyShift action_39
action_26 (44) = happyShift action_40
action_26 (45) = happyShift action_41
action_26 (46) = happyShift action_42
action_26 (47) = happyShift action_43
action_26 (48) = happyShift action_44
action_26 (49) = happyShift action_45
action_26 (50) = happyShift action_46
action_26 (51) = happyShift action_47
action_26 (52) = happyShift action_48
action_26 (53) = happyShift action_49
action_26 (54) = happyShift action_50
action_26 _ = happyFail

action_27 (27) = happyShift action_12
action_27 (28) = happyShift action_13
action_27 (29) = happyShift action_14
action_27 (33) = happyShift action_15
action_27 (34) = happyShift action_16
action_27 (35) = happyShift action_17
action_27 (42) = happyShift action_18
action_27 (55) = happyShift action_19
action_27 (58) = happyShift action_20
action_27 (10) = happyGoto action_98
action_27 _ = happyFail

action_28 (27) = happyShift action_12
action_28 (28) = happyShift action_13
action_28 (29) = happyShift action_14
action_28 (33) = happyShift action_15
action_28 (34) = happyShift action_16
action_28 (35) = happyShift action_17
action_28 (42) = happyShift action_18
action_28 (55) = happyShift action_19
action_28 (58) = happyShift action_20
action_28 (10) = happyGoto action_97
action_28 _ = happyFail

action_29 (27) = happyShift action_12
action_29 (28) = happyShift action_13
action_29 (29) = happyShift action_14
action_29 (33) = happyShift action_15
action_29 (34) = happyShift action_16
action_29 (35) = happyShift action_17
action_29 (42) = happyShift action_18
action_29 (55) = happyShift action_19
action_29 (58) = happyShift action_20
action_29 (10) = happyGoto action_96
action_29 _ = happyFail

action_30 (27) = happyShift action_12
action_30 (28) = happyShift action_13
action_30 (29) = happyShift action_14
action_30 (33) = happyShift action_15
action_30 (34) = happyShift action_16
action_30 (35) = happyShift action_17
action_30 (42) = happyShift action_18
action_30 (55) = happyShift action_19
action_30 (58) = happyShift action_20
action_30 (10) = happyGoto action_95
action_30 _ = happyFail

action_31 (27) = happyShift action_12
action_31 (28) = happyShift action_13
action_31 (29) = happyShift action_14
action_31 (33) = happyShift action_15
action_31 (34) = happyShift action_16
action_31 (35) = happyShift action_17
action_31 (42) = happyShift action_18
action_31 (55) = happyShift action_19
action_31 (58) = happyShift action_20
action_31 (10) = happyGoto action_94
action_31 _ = happyFail

action_32 (27) = happyShift action_12
action_32 (28) = happyShift action_13
action_32 (29) = happyShift action_14
action_32 (33) = happyShift action_15
action_32 (34) = happyShift action_16
action_32 (35) = happyShift action_17
action_32 (42) = happyShift action_18
action_32 (55) = happyShift action_19
action_32 (58) = happyShift action_20
action_32 (10) = happyGoto action_93
action_32 _ = happyFail

action_33 (27) = happyShift action_12
action_33 (28) = happyShift action_13
action_33 (29) = happyShift action_14
action_33 (33) = happyShift action_15
action_33 (34) = happyShift action_16
action_33 (35) = happyShift action_17
action_33 (42) = happyShift action_18
action_33 (55) = happyShift action_19
action_33 (58) = happyShift action_20
action_33 (10) = happyGoto action_92
action_33 _ = happyFail

action_34 (27) = happyShift action_12
action_34 (28) = happyShift action_13
action_34 (29) = happyShift action_14
action_34 (33) = happyShift action_15
action_34 (34) = happyShift action_16
action_34 (35) = happyShift action_17
action_34 (42) = happyShift action_18
action_34 (55) = happyShift action_19
action_34 (58) = happyShift action_20
action_34 (10) = happyGoto action_91
action_34 _ = happyFail

action_35 (27) = happyShift action_12
action_35 (28) = happyShift action_13
action_35 (29) = happyShift action_14
action_35 (33) = happyShift action_15
action_35 (34) = happyShift action_16
action_35 (35) = happyShift action_17
action_35 (42) = happyShift action_18
action_35 (55) = happyShift action_19
action_35 (58) = happyShift action_20
action_35 (10) = happyGoto action_90
action_35 _ = happyFail

action_36 (27) = happyShift action_12
action_36 (28) = happyShift action_13
action_36 (29) = happyShift action_14
action_36 (33) = happyShift action_15
action_36 (34) = happyShift action_16
action_36 (35) = happyShift action_17
action_36 (42) = happyShift action_18
action_36 (55) = happyShift action_19
action_36 (58) = happyShift action_20
action_36 (10) = happyGoto action_89
action_36 _ = happyFail

action_37 (27) = happyShift action_12
action_37 (28) = happyShift action_13
action_37 (29) = happyShift action_14
action_37 (33) = happyShift action_15
action_37 (34) = happyShift action_16
action_37 (35) = happyShift action_17
action_37 (42) = happyShift action_18
action_37 (55) = happyShift action_19
action_37 (58) = happyShift action_20
action_37 (10) = happyGoto action_88
action_37 _ = happyFail

action_38 (27) = happyShift action_12
action_38 (28) = happyShift action_13
action_38 (29) = happyShift action_14
action_38 (33) = happyShift action_15
action_38 (34) = happyShift action_16
action_38 (35) = happyShift action_17
action_38 (42) = happyShift action_18
action_38 (55) = happyShift action_19
action_38 (58) = happyShift action_20
action_38 (10) = happyGoto action_87
action_38 _ = happyFail

action_39 (27) = happyShift action_12
action_39 (28) = happyShift action_13
action_39 (29) = happyShift action_14
action_39 (33) = happyShift action_15
action_39 (34) = happyShift action_16
action_39 (35) = happyShift action_17
action_39 (42) = happyShift action_18
action_39 (55) = happyShift action_19
action_39 (58) = happyShift action_20
action_39 (10) = happyGoto action_86
action_39 _ = happyFail

action_40 (27) = happyShift action_12
action_40 (28) = happyShift action_13
action_40 (29) = happyShift action_14
action_40 (33) = happyShift action_15
action_40 (34) = happyShift action_16
action_40 (35) = happyShift action_17
action_40 (42) = happyShift action_18
action_40 (55) = happyShift action_19
action_40 (58) = happyShift action_20
action_40 (10) = happyGoto action_85
action_40 _ = happyFail

action_41 (27) = happyShift action_12
action_41 (28) = happyShift action_13
action_41 (29) = happyShift action_14
action_41 (33) = happyShift action_15
action_41 (34) = happyShift action_16
action_41 (35) = happyShift action_17
action_41 (42) = happyShift action_18
action_41 (55) = happyShift action_19
action_41 (58) = happyShift action_20
action_41 (10) = happyGoto action_84
action_41 _ = happyFail

action_42 (27) = happyShift action_12
action_42 (28) = happyShift action_13
action_42 (29) = happyShift action_14
action_42 (33) = happyShift action_15
action_42 (34) = happyShift action_16
action_42 (35) = happyShift action_17
action_42 (42) = happyShift action_18
action_42 (55) = happyShift action_19
action_42 (58) = happyShift action_20
action_42 (10) = happyGoto action_83
action_42 _ = happyFail

action_43 (27) = happyShift action_12
action_43 (28) = happyShift action_13
action_43 (29) = happyShift action_14
action_43 (33) = happyShift action_15
action_43 (34) = happyShift action_16
action_43 (35) = happyShift action_17
action_43 (42) = happyShift action_18
action_43 (55) = happyShift action_19
action_43 (58) = happyShift action_20
action_43 (10) = happyGoto action_82
action_43 _ = happyFail

action_44 (27) = happyShift action_12
action_44 (28) = happyShift action_13
action_44 (29) = happyShift action_14
action_44 (33) = happyShift action_15
action_44 (34) = happyShift action_16
action_44 (35) = happyShift action_17
action_44 (42) = happyShift action_18
action_44 (55) = happyShift action_19
action_44 (58) = happyShift action_20
action_44 (10) = happyGoto action_81
action_44 _ = happyFail

action_45 (27) = happyShift action_12
action_45 (28) = happyShift action_13
action_45 (29) = happyShift action_14
action_45 (33) = happyShift action_15
action_45 (34) = happyShift action_16
action_45 (35) = happyShift action_17
action_45 (42) = happyShift action_18
action_45 (55) = happyShift action_19
action_45 (58) = happyShift action_20
action_45 (10) = happyGoto action_80
action_45 _ = happyFail

action_46 (27) = happyShift action_12
action_46 (28) = happyShift action_13
action_46 (29) = happyShift action_14
action_46 (33) = happyShift action_15
action_46 (34) = happyShift action_16
action_46 (35) = happyShift action_17
action_46 (42) = happyShift action_18
action_46 (55) = happyShift action_19
action_46 (58) = happyShift action_20
action_46 (10) = happyGoto action_79
action_46 _ = happyFail

action_47 (27) = happyShift action_12
action_47 (28) = happyShift action_13
action_47 (29) = happyShift action_14
action_47 (33) = happyShift action_15
action_47 (34) = happyShift action_16
action_47 (35) = happyShift action_17
action_47 (42) = happyShift action_18
action_47 (55) = happyShift action_19
action_47 (58) = happyShift action_20
action_47 (10) = happyGoto action_78
action_47 _ = happyFail

action_48 (27) = happyShift action_12
action_48 (28) = happyShift action_13
action_48 (29) = happyShift action_14
action_48 (33) = happyShift action_15
action_48 (34) = happyShift action_16
action_48 (35) = happyShift action_17
action_48 (42) = happyShift action_18
action_48 (55) = happyShift action_19
action_48 (58) = happyShift action_20
action_48 (10) = happyGoto action_77
action_48 _ = happyFail

action_49 (27) = happyShift action_12
action_49 (28) = happyShift action_13
action_49 (29) = happyShift action_14
action_49 (33) = happyShift action_15
action_49 (34) = happyShift action_16
action_49 (35) = happyShift action_17
action_49 (42) = happyShift action_18
action_49 (55) = happyShift action_19
action_49 (58) = happyShift action_20
action_49 (10) = happyGoto action_76
action_49 _ = happyFail

action_50 (27) = happyShift action_12
action_50 (28) = happyShift action_13
action_50 (29) = happyShift action_14
action_50 (33) = happyShift action_15
action_50 (34) = happyShift action_16
action_50 (35) = happyShift action_17
action_50 (42) = happyShift action_18
action_50 (55) = happyShift action_19
action_50 (58) = happyShift action_20
action_50 (10) = happyGoto action_75
action_50 _ = happyFail

action_51 _ = happyReduce_6

action_52 _ = happyReduce_2

action_53 _ = happyReduce_3

action_54 _ = happyReduce_4

action_55 (12) = happyShift action_4
action_55 (13) = happyShift action_5
action_55 (14) = happyShift action_6
action_55 (15) = happyShift action_7
action_55 (16) = happyShift action_8
action_55 (17) = happyShift action_9
action_55 (18) = happyShift action_10
action_55 (27) = happyShift action_2
action_55 (4) = happyGoto action_68
action_55 (6) = happyGoto action_74
action_55 _ = happyReduce_12

action_56 (12) = happyShift action_4
action_56 (13) = happyShift action_5
action_56 (14) = happyShift action_6
action_56 (15) = happyShift action_7
action_56 (16) = happyShift action_8
action_56 (17) = happyShift action_9
action_56 (18) = happyShift action_10
action_56 (27) = happyShift action_2
action_56 (4) = happyGoto action_68
action_56 (6) = happyGoto action_73
action_56 _ = happyReduce_12

action_57 (12) = happyShift action_4
action_57 (13) = happyShift action_5
action_57 (14) = happyShift action_6
action_57 (15) = happyShift action_7
action_57 (16) = happyShift action_8
action_57 (17) = happyShift action_9
action_57 (18) = happyShift action_10
action_57 (27) = happyShift action_2
action_57 (4) = happyGoto action_68
action_57 (6) = happyGoto action_72
action_57 _ = happyReduce_12

action_58 (12) = happyShift action_4
action_58 (13) = happyShift action_5
action_58 (14) = happyShift action_6
action_58 (15) = happyShift action_7
action_58 (16) = happyShift action_8
action_58 (17) = happyShift action_9
action_58 (18) = happyShift action_10
action_58 (27) = happyShift action_2
action_58 (4) = happyGoto action_68
action_58 (6) = happyGoto action_71
action_58 _ = happyReduce_12

action_59 (28) = happyShift action_28
action_59 (29) = happyShift action_29
action_59 (30) = happyShift action_30
action_59 (31) = happyShift action_31
action_59 (32) = happyShift action_32
action_59 (36) = happyShift action_33
action_59 (37) = happyShift action_34
action_59 (38) = happyShift action_35
action_59 (39) = happyShift action_36
action_59 (40) = happyShift action_37
action_59 (41) = happyShift action_38
action_59 (43) = happyShift action_39
action_59 (44) = happyShift action_40
action_59 (45) = happyShift action_41
action_59 (46) = happyShift action_42
action_59 (47) = happyShift action_43
action_59 (48) = happyShift action_44
action_59 (49) = happyShift action_45
action_59 (50) = happyShift action_46
action_59 (51) = happyShift action_47
action_59 (52) = happyShift action_48
action_59 (53) = happyShift action_49
action_59 (54) = happyShift action_50
action_59 (56) = happyShift action_70
action_59 _ = happyFail

action_60 _ = happyReduce_25

action_61 _ = happyReduce_24

action_62 _ = happyReduce_27

action_63 _ = happyReduce_26

action_64 _ = happyReduce_29

action_65 _ = happyReduce_28

action_66 _ = happyReduce_23

action_67 (12) = happyShift action_4
action_67 (13) = happyShift action_5
action_67 (14) = happyShift action_6
action_67 (15) = happyShift action_7
action_67 (16) = happyShift action_8
action_67 (17) = happyShift action_9
action_67 (18) = happyShift action_10
action_67 (27) = happyShift action_2
action_67 (4) = happyGoto action_68
action_67 (6) = happyGoto action_69
action_67 _ = happyReduce_12

action_68 (12) = happyShift action_4
action_68 (13) = happyShift action_5
action_68 (14) = happyShift action_6
action_68 (15) = happyShift action_7
action_68 (16) = happyShift action_8
action_68 (17) = happyShift action_9
action_68 (18) = happyShift action_10
action_68 (27) = happyShift action_2
action_68 (4) = happyGoto action_68
action_68 (6) = happyGoto action_108
action_68 _ = happyReduce_12

action_69 (25) = happyShift action_107
action_69 _ = happyFail

action_70 _ = happyReduce_30

action_71 (25) = happyShift action_106
action_71 _ = happyFail

action_72 (19) = happyShift action_103
action_72 (21) = happyShift action_104
action_72 (24) = happyShift action_105
action_72 (7) = happyGoto action_102
action_72 _ = happyFail

action_73 (25) = happyShift action_101
action_73 _ = happyFail

action_74 (24) = happyShift action_100
action_74 _ = happyFail

action_75 (28) = happyShift action_28
action_75 (29) = happyShift action_29
action_75 (30) = happyShift action_30
action_75 (31) = happyShift action_31
action_75 (32) = happyShift action_32
action_75 (36) = happyShift action_33
action_75 (37) = happyShift action_34
action_75 (38) = happyShift action_35
action_75 (39) = happyShift action_36
action_75 (40) = happyShift action_37
action_75 (41) = happyShift action_38
action_75 (43) = happyShift action_39
action_75 (44) = happyShift action_40
action_75 (45) = happyShift action_41
action_75 (46) = happyShift action_42
action_75 (47) = happyShift action_43
action_75 (48) = happyShift action_44
action_75 (51) = happyFail
action_75 (52) = happyFail
action_75 (53) = happyFail
action_75 (54) = happyFail
action_75 _ = happyReduce_53

action_76 (28) = happyShift action_28
action_76 (29) = happyShift action_29
action_76 (30) = happyShift action_30
action_76 (31) = happyShift action_31
action_76 (32) = happyShift action_32
action_76 (36) = happyShift action_33
action_76 (37) = happyShift action_34
action_76 (38) = happyShift action_35
action_76 (39) = happyShift action_36
action_76 (40) = happyShift action_37
action_76 (41) = happyShift action_38
action_76 (43) = happyShift action_39
action_76 (44) = happyShift action_40
action_76 (45) = happyShift action_41
action_76 (46) = happyShift action_42
action_76 (47) = happyShift action_43
action_76 (48) = happyShift action_44
action_76 (51) = happyFail
action_76 (52) = happyFail
action_76 (53) = happyFail
action_76 (54) = happyFail
action_76 _ = happyReduce_52

action_77 (28) = happyShift action_28
action_77 (29) = happyShift action_29
action_77 (30) = happyShift action_30
action_77 (31) = happyShift action_31
action_77 (32) = happyShift action_32
action_77 (36) = happyShift action_33
action_77 (37) = happyShift action_34
action_77 (38) = happyShift action_35
action_77 (39) = happyShift action_36
action_77 (40) = happyShift action_37
action_77 (41) = happyShift action_38
action_77 (43) = happyShift action_39
action_77 (44) = happyShift action_40
action_77 (45) = happyShift action_41
action_77 (46) = happyShift action_42
action_77 (47) = happyShift action_43
action_77 (48) = happyShift action_44
action_77 (51) = happyFail
action_77 (52) = happyFail
action_77 (53) = happyFail
action_77 (54) = happyFail
action_77 _ = happyReduce_51

action_78 (28) = happyShift action_28
action_78 (29) = happyShift action_29
action_78 (30) = happyShift action_30
action_78 (31) = happyShift action_31
action_78 (32) = happyShift action_32
action_78 (36) = happyShift action_33
action_78 (37) = happyShift action_34
action_78 (38) = happyShift action_35
action_78 (39) = happyShift action_36
action_78 (40) = happyShift action_37
action_78 (41) = happyShift action_38
action_78 (43) = happyShift action_39
action_78 (44) = happyShift action_40
action_78 (45) = happyShift action_41
action_78 (46) = happyShift action_42
action_78 (47) = happyShift action_43
action_78 (48) = happyShift action_44
action_78 (51) = happyFail
action_78 (52) = happyFail
action_78 (53) = happyFail
action_78 (54) = happyFail
action_78 _ = happyReduce_50

action_79 (28) = happyShift action_28
action_79 (29) = happyShift action_29
action_79 (30) = happyShift action_30
action_79 (31) = happyShift action_31
action_79 (32) = happyShift action_32
action_79 (36) = happyShift action_33
action_79 (37) = happyShift action_34
action_79 (38) = happyShift action_35
action_79 (39) = happyShift action_36
action_79 (40) = happyShift action_37
action_79 (41) = happyShift action_38
action_79 (43) = happyShift action_39
action_79 (44) = happyShift action_40
action_79 (45) = happyShift action_41
action_79 (46) = happyShift action_42
action_79 (47) = happyShift action_43
action_79 (48) = happyShift action_44
action_79 (49) = happyFail
action_79 (50) = happyFail
action_79 (51) = happyShift action_47
action_79 (52) = happyShift action_48
action_79 (53) = happyShift action_49
action_79 (54) = happyShift action_50
action_79 _ = happyReduce_49

action_80 (28) = happyShift action_28
action_80 (29) = happyShift action_29
action_80 (30) = happyShift action_30
action_80 (31) = happyShift action_31
action_80 (32) = happyShift action_32
action_80 (36) = happyShift action_33
action_80 (37) = happyShift action_34
action_80 (38) = happyShift action_35
action_80 (39) = happyShift action_36
action_80 (40) = happyShift action_37
action_80 (41) = happyShift action_38
action_80 (43) = happyShift action_39
action_80 (44) = happyShift action_40
action_80 (45) = happyShift action_41
action_80 (46) = happyShift action_42
action_80 (47) = happyShift action_43
action_80 (48) = happyShift action_44
action_80 (49) = happyFail
action_80 (50) = happyFail
action_80 (51) = happyShift action_47
action_80 (52) = happyShift action_48
action_80 (53) = happyShift action_49
action_80 (54) = happyShift action_50
action_80 _ = happyReduce_48

action_81 (28) = happyShift action_28
action_81 (29) = happyShift action_29
action_81 (30) = happyShift action_30
action_81 (31) = happyShift action_31
action_81 (32) = happyShift action_32
action_81 _ = happyReduce_47

action_82 (28) = happyShift action_28
action_82 (29) = happyShift action_29
action_82 (30) = happyShift action_30
action_82 (31) = happyShift action_31
action_82 (32) = happyShift action_32
action_82 _ = happyReduce_46

action_83 (28) = happyShift action_28
action_83 (29) = happyShift action_29
action_83 (30) = happyShift action_30
action_83 (31) = happyShift action_31
action_83 (32) = happyShift action_32
action_83 _ = happyReduce_45

action_84 (28) = happyShift action_28
action_84 (29) = happyShift action_29
action_84 (30) = happyShift action_30
action_84 (31) = happyShift action_31
action_84 (32) = happyShift action_32
action_84 _ = happyReduce_44

action_85 (28) = happyShift action_28
action_85 (29) = happyShift action_29
action_85 (30) = happyShift action_30
action_85 (31) = happyShift action_31
action_85 (32) = happyShift action_32
action_85 _ = happyReduce_43

action_86 (28) = happyShift action_28
action_86 (29) = happyShift action_29
action_86 (30) = happyShift action_30
action_86 (31) = happyShift action_31
action_86 (32) = happyShift action_32
action_86 _ = happyReduce_42

action_87 (28) = happyShift action_28
action_87 (29) = happyShift action_29
action_87 (30) = happyShift action_30
action_87 (31) = happyShift action_31
action_87 (32) = happyShift action_32
action_87 (43) = happyShift action_39
action_87 (44) = happyShift action_40
action_87 (45) = happyShift action_41
action_87 (46) = happyShift action_42
action_87 (47) = happyShift action_43
action_87 (48) = happyShift action_44
action_87 _ = happyReduce_41

action_88 (28) = happyShift action_28
action_88 (29) = happyShift action_29
action_88 (30) = happyShift action_30
action_88 (31) = happyShift action_31
action_88 (32) = happyShift action_32
action_88 (43) = happyShift action_39
action_88 (44) = happyShift action_40
action_88 (45) = happyShift action_41
action_88 (46) = happyShift action_42
action_88 (47) = happyShift action_43
action_88 (48) = happyShift action_44
action_88 _ = happyReduce_40

action_89 (28) = happyShift action_28
action_89 (29) = happyShift action_29
action_89 (30) = happyShift action_30
action_89 (31) = happyShift action_31
action_89 (32) = happyShift action_32
action_89 (43) = happyShift action_39
action_89 (44) = happyShift action_40
action_89 (45) = happyShift action_41
action_89 (46) = happyShift action_42
action_89 (47) = happyShift action_43
action_89 (48) = happyShift action_44
action_89 _ = happyReduce_39

action_90 (28) = happyShift action_28
action_90 (29) = happyShift action_29
action_90 (30) = happyShift action_30
action_90 (31) = happyShift action_31
action_90 (32) = happyShift action_32
action_90 (43) = happyShift action_39
action_90 (44) = happyShift action_40
action_90 (45) = happyShift action_41
action_90 (46) = happyShift action_42
action_90 (47) = happyShift action_43
action_90 (48) = happyShift action_44
action_90 _ = happyReduce_38

action_91 (28) = happyShift action_28
action_91 (29) = happyShift action_29
action_91 (30) = happyShift action_30
action_91 (31) = happyShift action_31
action_91 (32) = happyShift action_32
action_91 (43) = happyShift action_39
action_91 (44) = happyShift action_40
action_91 (45) = happyShift action_41
action_91 (46) = happyShift action_42
action_91 (47) = happyShift action_43
action_91 (48) = happyShift action_44
action_91 _ = happyReduce_37

action_92 (28) = happyShift action_28
action_92 (29) = happyShift action_29
action_92 (30) = happyShift action_30
action_92 (31) = happyShift action_31
action_92 (32) = happyShift action_32
action_92 (43) = happyShift action_39
action_92 (44) = happyShift action_40
action_92 (45) = happyShift action_41
action_92 (46) = happyShift action_42
action_92 (47) = happyShift action_43
action_92 (48) = happyShift action_44
action_92 _ = happyReduce_36

action_93 _ = happyReduce_35

action_94 _ = happyReduce_34

action_95 _ = happyReduce_33

action_96 (30) = happyShift action_30
action_96 (31) = happyShift action_31
action_96 (32) = happyShift action_32
action_96 _ = happyReduce_32

action_97 (30) = happyShift action_30
action_97 (31) = happyShift action_31
action_97 (32) = happyShift action_32
action_97 _ = happyReduce_31

action_98 (26) = happyShift action_99
action_98 (28) = happyShift action_28
action_98 (29) = happyShift action_29
action_98 (30) = happyShift action_30
action_98 (31) = happyShift action_31
action_98 (32) = happyShift action_32
action_98 (36) = happyShift action_33
action_98 (37) = happyShift action_34
action_98 (38) = happyShift action_35
action_98 (39) = happyShift action_36
action_98 (40) = happyShift action_37
action_98 (41) = happyShift action_38
action_98 (43) = happyShift action_39
action_98 (44) = happyShift action_40
action_98 (45) = happyShift action_41
action_98 (46) = happyShift action_42
action_98 (47) = happyShift action_43
action_98 (48) = happyShift action_44
action_98 (49) = happyShift action_45
action_98 (50) = happyShift action_46
action_98 (51) = happyShift action_47
action_98 (52) = happyShift action_48
action_98 (53) = happyShift action_49
action_98 (54) = happyShift action_50
action_98 _ = happyFail

action_99 _ = happyReduce_1

action_100 _ = happyReduce_10

action_101 _ = happyReduce_11

action_102 _ = happyReduce_7

action_103 (12) = happyShift action_4
action_103 (13) = happyShift action_5
action_103 (14) = happyShift action_6
action_103 (15) = happyShift action_7
action_103 (16) = happyShift action_8
action_103 (17) = happyShift action_9
action_103 (18) = happyShift action_10
action_103 (27) = happyShift action_2
action_103 (4) = happyGoto action_68
action_103 (6) = happyGoto action_115
action_103 _ = happyReduce_12

action_104 (27) = happyShift action_12
action_104 (28) = happyShift action_13
action_104 (29) = happyShift action_14
action_104 (33) = happyShift action_15
action_104 (34) = happyShift action_16
action_104 (35) = happyShift action_17
action_104 (42) = happyShift action_18
action_104 (55) = happyShift action_19
action_104 (58) = happyShift action_20
action_104 (10) = happyGoto action_114
action_104 _ = happyFail

action_105 _ = happyReduce_14

action_106 (19) = happyShift action_112
action_106 (21) = happyShift action_113
action_106 (9) = happyGoto action_111
action_106 _ = happyReduce_20

action_107 (20) = happyShift action_110
action_107 (8) = happyGoto action_109
action_107 _ = happyReduce_17

action_108 _ = happyReduce_13

action_109 _ = happyReduce_8

action_110 (23) = happyShift action_121
action_110 (27) = happyShift action_12
action_110 (28) = happyShift action_13
action_110 (29) = happyShift action_14
action_110 (33) = happyShift action_15
action_110 (34) = happyShift action_16
action_110 (35) = happyShift action_17
action_110 (42) = happyShift action_18
action_110 (55) = happyShift action_19
action_110 (58) = happyShift action_20
action_110 (10) = happyGoto action_120
action_110 _ = happyFail

action_111 _ = happyReduce_9

action_112 (23) = happyShift action_119
action_112 _ = happyFail

action_113 (27) = happyShift action_12
action_113 (28) = happyShift action_13
action_113 (29) = happyShift action_14
action_113 (33) = happyShift action_15
action_113 (34) = happyShift action_16
action_113 (35) = happyShift action_17
action_113 (42) = happyShift action_18
action_113 (55) = happyShift action_19
action_113 (58) = happyShift action_20
action_113 (10) = happyGoto action_118
action_113 _ = happyFail

action_114 (22) = happyShift action_117
action_114 (28) = happyShift action_28
action_114 (29) = happyShift action_29
action_114 (30) = happyShift action_30
action_114 (31) = happyShift action_31
action_114 (32) = happyShift action_32
action_114 (36) = happyShift action_33
action_114 (37) = happyShift action_34
action_114 (38) = happyShift action_35
action_114 (39) = happyShift action_36
action_114 (40) = happyShift action_37
action_114 (41) = happyShift action_38
action_114 (43) = happyShift action_39
action_114 (44) = happyShift action_40
action_114 (45) = happyShift action_41
action_114 (46) = happyShift action_42
action_114 (47) = happyShift action_43
action_114 (48) = happyShift action_44
action_114 (49) = happyShift action_45
action_114 (50) = happyShift action_46
action_114 (51) = happyShift action_47
action_114 (52) = happyShift action_48
action_114 (53) = happyShift action_49
action_114 (54) = happyShift action_50
action_114 _ = happyFail

action_115 (24) = happyShift action_116
action_115 _ = happyFail

action_116 _ = happyReduce_15

action_117 (12) = happyShift action_4
action_117 (13) = happyShift action_5
action_117 (14) = happyShift action_6
action_117 (15) = happyShift action_7
action_117 (16) = happyShift action_8
action_117 (17) = happyShift action_9
action_117 (18) = happyShift action_10
action_117 (27) = happyShift action_2
action_117 (4) = happyGoto action_68
action_117 (6) = happyGoto action_126
action_117 _ = happyReduce_12

action_118 (23) = happyShift action_125
action_118 (28) = happyShift action_28
action_118 (29) = happyShift action_29
action_118 (30) = happyShift action_30
action_118 (31) = happyShift action_31
action_118 (32) = happyShift action_32
action_118 (36) = happyShift action_33
action_118 (37) = happyShift action_34
action_118 (38) = happyShift action_35
action_118 (39) = happyShift action_36
action_118 (40) = happyShift action_37
action_118 (41) = happyShift action_38
action_118 (43) = happyShift action_39
action_118 (44) = happyShift action_40
action_118 (45) = happyShift action_41
action_118 (46) = happyShift action_42
action_118 (47) = happyShift action_43
action_118 (48) = happyShift action_44
action_118 (49) = happyShift action_45
action_118 (50) = happyShift action_46
action_118 (51) = happyShift action_47
action_118 (52) = happyShift action_48
action_118 (53) = happyShift action_49
action_118 (54) = happyShift action_50
action_118 _ = happyFail

action_119 (12) = happyShift action_4
action_119 (13) = happyShift action_5
action_119 (14) = happyShift action_6
action_119 (15) = happyShift action_7
action_119 (16) = happyShift action_8
action_119 (17) = happyShift action_9
action_119 (18) = happyShift action_10
action_119 (27) = happyShift action_2
action_119 (4) = happyGoto action_68
action_119 (6) = happyGoto action_124
action_119 _ = happyReduce_12

action_120 (23) = happyShift action_123
action_120 (28) = happyShift action_28
action_120 (29) = happyShift action_29
action_120 (30) = happyShift action_30
action_120 (31) = happyShift action_31
action_120 (32) = happyShift action_32
action_120 (36) = happyShift action_33
action_120 (37) = happyShift action_34
action_120 (38) = happyShift action_35
action_120 (39) = happyShift action_36
action_120 (40) = happyShift action_37
action_120 (41) = happyShift action_38
action_120 (43) = happyShift action_39
action_120 (44) = happyShift action_40
action_120 (45) = happyShift action_41
action_120 (46) = happyShift action_42
action_120 (47) = happyShift action_43
action_120 (48) = happyShift action_44
action_120 (49) = happyShift action_45
action_120 (50) = happyShift action_46
action_120 (51) = happyShift action_47
action_120 (52) = happyShift action_48
action_120 (53) = happyShift action_49
action_120 (54) = happyShift action_50
action_120 _ = happyFail

action_121 (12) = happyShift action_4
action_121 (13) = happyShift action_5
action_121 (14) = happyShift action_6
action_121 (15) = happyShift action_7
action_121 (16) = happyShift action_8
action_121 (17) = happyShift action_9
action_121 (18) = happyShift action_10
action_121 (27) = happyShift action_2
action_121 (4) = happyGoto action_68
action_121 (6) = happyGoto action_122
action_121 _ = happyReduce_12

action_122 (25) = happyShift action_131
action_122 _ = happyFail

action_123 (12) = happyShift action_4
action_123 (13) = happyShift action_5
action_123 (14) = happyShift action_6
action_123 (15) = happyShift action_7
action_123 (16) = happyShift action_8
action_123 (17) = happyShift action_9
action_123 (18) = happyShift action_10
action_123 (27) = happyShift action_2
action_123 (4) = happyGoto action_68
action_123 (6) = happyGoto action_130
action_123 _ = happyReduce_12

action_124 (25) = happyShift action_129
action_124 _ = happyFail

action_125 (12) = happyShift action_4
action_125 (13) = happyShift action_5
action_125 (14) = happyShift action_6
action_125 (15) = happyShift action_7
action_125 (16) = happyShift action_8
action_125 (17) = happyShift action_9
action_125 (18) = happyShift action_10
action_125 (27) = happyShift action_2
action_125 (4) = happyGoto action_68
action_125 (6) = happyGoto action_128
action_125 _ = happyReduce_12

action_126 (19) = happyShift action_103
action_126 (21) = happyShift action_104
action_126 (24) = happyShift action_105
action_126 (7) = happyGoto action_127
action_126 _ = happyFail

action_127 _ = happyReduce_16

action_128 (25) = happyShift action_133
action_128 _ = happyFail

action_129 _ = happyReduce_21

action_130 (25) = happyShift action_132
action_130 _ = happyFail

action_131 _ = happyReduce_18

action_132 (20) = happyShift action_110
action_132 (8) = happyGoto action_135
action_132 _ = happyReduce_17

action_133 (19) = happyShift action_112
action_133 (21) = happyShift action_113
action_133 (9) = happyGoto action_134
action_133 _ = happyReduce_20

action_134 _ = happyReduce_22

action_135 _ = happyReduce_19

happyReduce_1 = happyReduce 5 4 happyReduction_1
happyReduction_1 (_ `HappyStk`
	(HappyAbsSyn10  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (Assign happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_2 = happySpecReduce_3  4 happyReduction_2
happyReduction_2 _
	(HappyTerminal happy_var_2)
	_
	 =  HappyAbsSyn4
		 (Flag   happy_var_2
	)
happyReduction_2 _ _ _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_3  4 happyReduction_3
happyReduction_3 _
	(HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn4
		 (Goto   happy_var_2
	)
happyReduction_3 _ _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_3  4 happyReduction_4
happyReduction_4 (HappyAbsSyn5  happy_var_3)
	(HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn4
		 (Loop   happy_var_2 happy_var_3
	)
happyReduction_4 _ _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_1  4 happyReduction_5
happyReduction_5 _
	 =  HappyAbsSyn4
		 (stop
	)

happyReduce_6 = happySpecReduce_3  4 happyReduction_6
happyReduction_6 _
	(HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn4
		 (print  happy_var_2
	)
happyReduction_6 _ _ _  = notHappyAtAll 

happyReduce_7 = happyReduce 5 4 happyReduction_7
happyReduction_7 ((HappyAbsSyn7  happy_var_5) `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (If  happy_var_2 happy_var_4 happy_var_5
	) `HappyStk` happyRest

happyReduce_8 = happyReduce 6 4 happyReduction_8
happyReduction_8 ((HappyAbsSyn8  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (If  happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_9 = happyReduce 6 4 happyReduction_9
happyReduction_9 ((HappyAbsSyn9  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 (If  happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_10 = happySpecReduce_3  5 happyReduction_10
happyReduction_10 _
	(HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn5
		 (happy_var_2
	)
happyReduction_10 _ _ _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_3  5 happyReduction_11
happyReduction_11 _
	(HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn5
		 (happy_var_2
	)
happyReduction_11 _ _ _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_0  6 happyReduction_12
happyReduction_12  =  HappyAbsSyn6
		 ([]
	)

happyReduce_13 = happySpecReduce_2  6 happyReduction_13
happyReduction_13 (HappyAbsSyn6  happy_var_2)
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn6
		 (happy_var_1 : happy_var_2
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_1  7 happyReduction_14
happyReduction_14 _
	 =  HappyAbsSyn7
		 ([]
	)

happyReduce_15 = happySpecReduce_3  7 happyReduction_15
happyReduction_15 _
	(HappyAbsSyn6  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (Else   happy_var_2
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happyReduce 5 7 happyReduction_16
happyReduction_16 ((HappyAbsSyn7  happy_var_5) `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (ElseIf happy_var_2 happy_var_4 happy_var_5
	) `HappyStk` happyRest

happyReduce_17 = happySpecReduce_0  8 happyReduction_17
happyReduction_17  =  HappyAbsSyn8
		 ([]
	)

happyReduce_18 = happyReduce 4 8 happyReduction_18
happyReduction_18 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 (Else   happy_var_3
	) `HappyStk` happyRest

happyReduce_19 = happyReduce 6 8 happyReduction_19
happyReduction_19 ((HappyAbsSyn8  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 (ElseIf happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_20 = happySpecReduce_0  9 happyReduction_20
happyReduction_20  =  HappyAbsSyn9
		 ([]
	)

happyReduce_21 = happyReduce 4 9 happyReduction_21
happyReduction_21 (_ `HappyStk`
	(HappyAbsSyn6  happy_var_3) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn9
		 (Else   happy_var_3
	) `HappyStk` happyRest

happyReduce_22 = happyReduce 6 9 happyReduction_22
happyReduction_22 ((HappyAbsSyn9  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn6  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn9
		 (ElseIf happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_23 = happySpecReduce_2  10 happyReduction_23
happyReduction_23 (HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (At      happy_var_2
	)
happyReduction_23 _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_2  10 happyReduction_24
happyReduction_24 (HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (Op Not  happy_var_2
	)
happyReduction_24 _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_2  10 happyReduction_25
happyReduction_25 (HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (Op BNot happy_var_2
	)
happyReduction_25 _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_2  10 happyReduction_26
happyReduction_26 (HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (Op Incr happy_var_2
	)
happyReduction_26 _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_2  10 happyReduction_27
happyReduction_27 (HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (Op Decr happy_var_2
	)
happyReduction_27 _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_2  10 happyReduction_28
happyReduction_28 (HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (Op Abs happy_var_2
	)
happyReduction_28 _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_2  10 happyReduction_29
happyReduction_29 (HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (Op Neg happy_var_2
	)
happyReduction_29 _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_3  10 happyReduction_30
happyReduction_30 _
	(HappyAbsSyn10  happy_var_2)
	_
	 =  HappyAbsSyn10
		 (happy_var_2
	)
happyReduction_30 _ _ _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_3  10 happyReduction_31
happyReduction_31 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op Add      happy_var_1 happy_var_3
	)
happyReduction_31 _ _ _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_3  10 happyReduction_32
happyReduction_32 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op Sub      happy_var_1 happy_var_3
	)
happyReduction_32 _ _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_3  10 happyReduction_33
happyReduction_33 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op Mul      happy_var_1 happy_var_3
	)
happyReduction_33 _ _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_3  10 happyReduction_34
happyReduction_34 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op Div      happy_var_1 happy_var_3
	)
happyReduction_34 _ _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  10 happyReduction_35
happyReduction_35 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op Mod      happy_var_1 happy_var_3
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_3  10 happyReduction_36
happyReduction_36 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op And      happy_var_1 happy_var_3
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  10 happyReduction_37
happyReduction_37 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op Or       happy_var_1 happy_var_3
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_3  10 happyReduction_38
happyReduction_38 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op Xor      happy_var_1 happy_var_3
	)
happyReduction_38 _ _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_3  10 happyReduction_39
happyReduction_39 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op Nand     happy_var_1 happy_var_3
	)
happyReduction_39 _ _ _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_3  10 happyReduction_40
happyReduction_40 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op Nor      happy_var_1 happy_var_3
	)
happyReduction_40 _ _ _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_3  10 happyReduction_41
happyReduction_41 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op Xnor     happy_var_1 happy_var_3
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_3  10 happyReduction_42
happyReduction_42 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op BNand    happy_var_1 happy_var_3
	)
happyReduction_42 _ _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_3  10 happyReduction_43
happyReduction_43 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op BOr      happy_var_1 happy_var_3
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  10 happyReduction_44
happyReduction_44 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op BXor     happy_var_1 happy_var_3
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  10 happyReduction_45
happyReduction_45 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op BNand    happy_var_1 happy_var_3
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_3  10 happyReduction_46
happyReduction_46 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op BNor     happy_var_1 happy_var_3
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  10 happyReduction_47
happyReduction_47 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op BXnor    happy_var_1 happy_var_3
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_3  10 happyReduction_48
happyReduction_48 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op Equals   happy_var_1 happy_var_3
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_3  10 happyReduction_49
happyReduction_49 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op Diff     happy_var_1 happy_var_3
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_3  10 happyReduction_50
happyReduction_50 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op Greater  happy_var_1 happy_var_3
	)
happyReduction_50 _ _ _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_3  10 happyReduction_51
happyReduction_51 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op Lesser   happy_var_1 happy_var_3
	)
happyReduction_51 _ _ _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_3  10 happyReduction_52
happyReduction_52 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op EquGreat happy_var_1 happy_var_3
	)
happyReduction_52 _ _ _  = notHappyAtAll 

happyReduce_53 = happySpecReduce_3  10 happyReduction_53
happyReduction_53 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (Op EquLess  happy_var_1 happy_var_3
	)
happyReduction_53 _ _ _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_1  10 happyReduction_54
happyReduction_54 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (Lit (LInt happy_var_1)
	)
happyReduction_54 _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 59 59 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	TokenAssign -> cont 11;
	TokenPrint -> cont 12;
	TokenFlag -> cont 13;
	TokenGoto -> cont 14;
	TokenLoop -> cont 15;
	TokenStop -> cont 16;
	TokenIf1 -> cont 17;
	TokenIf2 -> cont 18;
	TokenElse1 -> cont 19;
	TokenElse2 -> cont 20;
	TokenElseIf -> cont 21;
	TokenBlockBegin1 -> cont 22;
	TokenBlockBegin2 -> cont 23;
	TokenBlockEnd1 -> cont 24;
	TokenBlockEnd2 -> cont 25;
	TokenInstrEnd -> cont 26;
	TokenAt -> cont 27;
	TokenAdd -> cont 28;
	TokenSub -> cont 29;
	TokenMul -> cont 30;
	TokenDiv -> cont 31;
	TokenMod -> cont 32;
	TokenIncr -> cont 33;
	TokenDecr -> cont 34;
	TokenNot -> cont 35;
	TokenAnd -> cont 36;
	TokenOr -> cont 37;
	TokenXor -> cont 38;
	TokenNand -> cont 39;
	TokenNor -> cont 40;
	TokenXnor -> cont 41;
	TokenBNot -> cont 42;
	TokenBAnd -> cont 43;
	TokenBOr -> cont 44;
	TokenBXor -> cont 45;
	TokenBNand -> cont 46;
	TokenBNor -> cont 47;
	TokenBXnor -> cont 48;
	TokenEquals -> cont 49;
	TokenDiff -> cont 50;
	TokenGreater -> cont 51;
	TokenLesser -> cont 52;
	TokenEquGreat -> cont 53;
	TokenEquLess -> cont 54;
	TokenLParen -> cont 55;
	TokenRParen -> cont 56;
	TokenSym String -> cont 57;
	TokenNum Int -> cont 58;
	_ -> happyError' (tk:tks)
	}

happyError_ 59 tk tks = happyError' tks
happyError_ _ tk tks = happyError' (tk:tks)

happyThen :: () => Except String a -> (a -> Except String b) -> Except String b
happyThen = ((>>=))
happyReturn :: () => a -> Except String a
happyReturn = (return)
happyThen1 m k tks = ((>>=)) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> Except String a
happyReturn1 = \a tks -> (return) a
happyError' :: () => [(Token)] -> Except String a
happyError' = parseError

expr tks = happySomeParser where
  happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: [Token] -> Except String a
parseError (l:ls) = throwError (show l)
parseError [] = throwError "Unexpected end of Input"

parseExpr :: String -> Either String Expr
parseExpr input = runExcept $ do
  tokenStream <- scanTokens input
  expr tokenStream

parseTokens :: String -> Either String [Token]
parseTokens = runExcept . scanTokens
{-# LINE 1 "templates\GenericTemplate.hs" #-}
{-# LINE 1 "templates\\GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command-line>" #-}
{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "G:\\GitHub\\haskell-platform\\build\\ghc-bindist\\local\\lib/include\\ghcversion.h" #-}















{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "C:\\Users\\randy\\AppData\\Local\\Temp\\ghc7776_0\\ghc_2.h" #-}




























































































































































{-# LINE 8 "<command-line>" #-}
{-# LINE 1 "templates\\GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

{-# LINE 13 "templates\\GenericTemplate.hs" #-}

{-# LINE 46 "templates\\GenericTemplate.hs" #-}








{-# LINE 67 "templates\\GenericTemplate.hs" #-}

{-# LINE 77 "templates\\GenericTemplate.hs" #-}

{-# LINE 86 "templates\\GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is (1), it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

{-# LINE 155 "templates\\GenericTemplate.hs" #-}

-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Int ->                    -- token number
         Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k - ((1) :: Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n - ((1) :: Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n - ((1)::Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

{-# LINE 256 "templates\\GenericTemplate.hs" #-}
happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery ((1) is the error token)

-- parse error if we are in recovery and we fail again
happyFail (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  (1) tk old_st (((HappyState (action))):(sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        action (1) (1) tk (HappyState (action)) sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail  i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ( (HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# LINE 322 "templates\\GenericTemplate.hs" #-}
{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
