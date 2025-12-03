module AoC2025

using DelimitedFiles

function get_input(day_number::Int)::String
    return "./input/$(day_number).txt"
end

function day01(path="")
    if length(path)==0
        path = get_input(1)
    end
    fxn_dict = Dict('L'=>Base.:-, 'R'=>Base.:+)

    state, part1 = 50, 0
    for line in readlines(path)
        d, m = line[1], parse(Int, line[2:end])
        state = fxn_dict[d](state, m)
        state = mod(state, 100)
        if state==0
            part1 += 1
        end
    end

    state, part2 = 50, 0
    for line in readlines(path)
        was_zero = state==0
        d, m = line[1], parse(Int, line[2:end])
        state = fxn_dict[d](state, m)
        x, state = fldmod(state, 100)
        if state==0
            part2 += 1
        end
        if x < 0 && was_zero
            x += 1
        elseif x > 0 && state==0
            x -= 1
        end
        part2 += abs(x)
    end

    return part1, part2
end

function day02(path::String="")
    part1 = 0
    if length(path)==0
        path = get_input(2)
    end
    ranges = [parse.(Int, x) for x in split.(split(readline(path), ","), "-")]

    for (x,y) in ranges
        for idx in x:y
            s = string(idx)
            if mod(length(s),2)==1
                continue
            end
            m = length(s)÷2
            first, second = s[1:m], s[m+1:end]
            if first!==second
                continue
            end
            part1 += idx

        end
    end

    part2, invalid_ids = 0, Int[]
    for (x, y) in ranges
        for idx in x:y
            skip = false
            s = string(idx)
            ls = length(s)
            z = mod(ls, 2)==0 ? ls÷2 : ls÷2+1
            for jdx in 1:ls-1
                if skip; continue; end

                d, mod = fldmod(ls, jdx)
                if mod!==0; continue; end
                if length(Set([s[i:i+jdx-1] for i in 1:jdx:ls])) > 1
                    continue
                end
                skip = true
                part2 += idx
            end
        end
    end

    return part1, part2
end

function day03(path::String="")
    if length(path)==0
        path = get_input(3)
    end

    function helper!(out, digits, target_depth)
        if target_depth==1
            push!(out, maximum(digits))
            return
        end
        idx = argmax(digits[1:end-target_depth+1])
        rest = digits[idx+1:end]
        push!(out, digits[idx])
        helper!(out, rest, target_depth-1)
    end

    part1 = 0
    for line in readlines(path)
        digits = parse.(Int, split(line, ""))
        out = Int[]
        helper!(out, digits, 2)
        part1 += sum(out .* [10^x for x in reverse(0:1)])
    end

    part2 = 0
    for line in readlines(path)
        digits = parse.(Int, split(line, ""))
        out = Int[]
        helper!(out, digits, 12)
        part2 += sum(out .* [10^x for x in reverse(0:11)])
    end
    return part1, part2

end

end # AoC2025
