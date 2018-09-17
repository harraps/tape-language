#( THIS IS A COMMENT )#

[8] # define mode 8bits
# main function
{
    @0 = "Hello World!";
    $0 < 0xC [
        (%) 5;
        (&) 63;
        ++$0;
        |> # break
        <| # continue
    ]
    ? $0 == 12 {
        # do stuff...
    } ! $0 == 11 && $1 != 10 {
        # do stuff...
    } {
        # do stuff...
    }
    @0 = $0 foo $0;
}

foo {
    *> $0;
}

#( verbose syntax )#

USE 8 BITS
MAIN
    AT 0 := "Hello World!".
    WHILE REG 0 < 12 DO
        WAIT 5.
        PRINT 63.
        ++ REG 0.
        STOP
        RETRY
    END
    IF REG 0 == 12 DO
        # do stuff...
    ELSEIF NOT REG 0 == 11 AND REG 1 != 10 DO
        # do stuff...
    ELSE
        # do stuff...
    END
    AT 0 := REG 0 foo 0.
END

foo DO
    RETURN REG 0.
END

☙ unicode ❧
❦ this is a comment
main
    at 0 = "Hello World!".
    while reg 0 < 12 do
        wait 5.
        print 63.
        ⭜ reg 0.
    end
    if reg 0 == 12 do
        ❦ do stuff...
    else if ¬ reg 0 == 11 ∧ reg 1 != 10 do
        ❦ do stuff...
    else
        ❦ do stuff...
    end
    at 0 := reg 0 foo 0.
end

foo do
    return reg 0.
end
