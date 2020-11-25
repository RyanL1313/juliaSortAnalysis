#=
Author: Ryan Lynch
Date: 11/21/2020
Section: CS 317-03

CS 317-03 Julia Honors Project portion

This program implements mergesort and quicksort on an array of strings. This array of strings is obtained from an input text file.
The program first performs mergesort on the array of strings, then it performs quicksort on an identical array.
The sorted data from each sort is written to separate output text files.
Timing information is obtained from the mergesort and quicksort algorithms and is used to compare the performance of the two.
The constant MAX_LINES can be modified to test out the performance of sorting a certain number of lines of strings.
=#

MAX_LINES = 1000000 # Number of lines you want to read in

# Driver function
function main()
    println("What is the name of your input file?")
    linesReadFileName = readline()

    println("What is the name of your output file for the data obtained using mergesort?")
    msWriteFileName = readline()

    println("What is the name of your output file for the data obtained using quicksort?")
    qsWriteFileName = readline()

    linesFile = open(linesReadFileName, "r")

    mergeSortLines = Array{String}(undef, MAX_LINES)
    quickSortLines = Array{String}(undef, MAX_LINES)
    temp = Array{String}(undef, MAX_LINES)

    i = 1; # Index used to add elements to the lines array in the loop
    while ! eof(linesFile) && i < MAX_LINES + 1
        line = readline(linesFile)
        mergeSortLines[i] = line
        quickSortLines[i] = line
        i += 1
    end

    # Running through the mergesort and quicksort functions in advance because @time will also factor in compile time when it first runs a function
    mergeSortLinesCopy = copy(mergeSortLines)
    quickSortLinesCopy = copy(quickSortLines)
    tempCopy = copy(temp)
    mergeSort!(mergeSortLinesCopy, 1, length(mergeSortLinesCopy), tempCopy)
    @time quickSort!(quickSortLinesCopy, 1, length(quickSortLinesCopy))

    # Perform the mergesort and quicksort, obtain the time and memory consumed for each sort using @time
    @time mergeSort!(mergeSortLines, 1, length(mergeSortLines), temp)
    @time quickSort!(quickSortLines, 1, length(quickSortLines))
end


function mergeSort!(lines::Array, first::Int, last::Int, temp::Array)

    if first < last
        middle = floor(Int, (first + last) / 2)

        mergeSort!(lines, first, middle, temp)
        mergeSort!(lines, middle + 1, last, temp)
        merge!(lines, first, last, temp)
    end
end

function merge!(lines::Array, first::Int, last::Int, temp::Array)
    middle = floor(Int, (first + last) / 2)
    leftArrIndex = first
    rightArrIndex = middle + 1
    rightLast = last
    leftLast = middle
    index = first

    while leftArrIndex <= middle && rightArrIndex <= last
        if lowercase(lines[leftArrIndex]) < lowercase(lines[rightArrIndex])
            temp[index] = lines[leftArrIndex]
            leftArrIndex += 1
        else
            temp[index] = lines[rightArrIndex]
            rightArrIndex += 1
        end

        index += 1
    end

    while leftArrIndex <= leftLast
        temp[index] = lines[leftArrIndex]
        index += 1
        leftArrIndex += 1
    end

    while rightArrIndex <= rightLast
        temp[index] = lines[rightArrIndex]
        index += 1
        rightArrIndex += 1
    end

    index = first
    while index <= rightLast
        lines[index] = temp[index]
        index += 1
    end
end


function quickSort!(lines::Array, left::Int, right::Int)
    if left < right
        split = hoarePartition!(lines, left, right)
        quickSort!(lines, left, split - 1)
        quickSort!(lines, split + 1, right)
    end
end


function hoarePartition!(lines::Array, left::Int, right::Int)
    pivot = left

    i = left
    j = right + 1

    while i < j
        i += 1
        while i < right && lowercase(lines[i]) < lowercase(lines[pivot])
            i += 1
        end
        j -= 1
        while lowercase(lines[j]) > lowercase(lines[pivot])
            j -= 1
        end

        temp = lines[i]
        lines[i] = lines[j]
        lines[j] = temp
    end

    temp = lines[i]
    lines[i] = lines[j]
    lines[j] = temp

    temp = lines[pivot]
    lines[pivot] = lines[j]
    lines[j] = temp

    return j
end


main()
