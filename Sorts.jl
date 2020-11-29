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

MAX_LINES = 100000 # Number of lines you want to read in

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
    quickSort!(quickSortLinesCopy, 1, length(quickSortLinesCopy))

    # Perform the mergesort and quicksort, obtain the time and memory consumed for each sort using @time
    @time mergeSort!(mergeSortLines, 1, length(mergeSortLines), temp)
    @time quickSort!(quickSortLines, 1, length(quickSortLines))

    # Write the sorted arrays to the output files specified by the user
    writeSortedArrayToFile(msWriteFileName, mergeSortLines)
    writeSortedArrayToFile(qsWriteFileName, quickSortLines)

end


#=
The mergesort algorithm.
Recursively divides the string lines array into 2 arrays, then combines these arrays in the merge step.

Parameters:
lines - the lines array
first - index of the first element in the subarray
last - index of the last element in the subarray
temp - the temporary array used to hold the sorted data throughout the mergesort operation
=#
function mergeSort!(lines::Array, first::Int, last::Int, temp::Array)

    if first < last
        middle = floor(Int, (first + last) / 2)

        mergeSort!(lines, first, middle, temp)
        mergeSort!(lines, middle + 1, last, temp)
        merge!(lines, first, last, temp)
    end
end


#=
The merge operation used in mergeSort.
Merges two sorted arrays into one sorted array by taking a pointer to the left half of the array and a pointer to the right half of the array
and comparing elements until one pointer reaches the end of its half of the array. The elements are put into the temp array as the comparisons happen.
Then, it copies the remaining elements in the array with unread elements to the temp array. The temp array is then copied into the lines array.
This step of mergesort takes O(n) time.
The string comparison works by viewing the strings in their lowercase form (using strToLower()) and then comparing the strings.

Parameters:
lines - the lines array
first - index of the first element in the subarray
last - index of the last element in the subarray
temp - the temporary array used to hold the sorted data throughout the mergesort operation
=#
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


#=
The quicksort algorithm.
Creates a split point where all elements to the left of the point are less than the element at the split, while all elements to the right are greater than the element at the split.
The element at the split point is then considered to be in its correct location. Quicksort is then recursively performed on all other elements around this split point.

Parameters:
lines - the lines array
left - the first index in this partition of the array
right - the last index in this partition of the array
=#
function quickSort!(lines::Array, left::Int, right::Int)
    if left < right
        split = hoarePartition!(lines, left, right)
        quickSort!(lines, left, split - 1)
        quickSort!(lines, split + 1, right)
    end
end


#=
The partitioning part of quicksort where a split point is identified.
Works by putting all elements less than the pivot in the left side of the array, and all elements greater in the right side.
The pivot element is swapped with the j index when i and j cross over, and then the j index is the split point.

Paramters:
lines - the lines array
left - the first index in this partition of the array
right - the last index in this partition of the array
=#
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


#=
Writes a sorted array to an output file.

Parameters:

outFileName - the output file name to write the sorted strings
lines - the sorted array of strings
=#
function writeSortedArrayToFile(outFileName, lines::Array)
    outFile = open(outFileName, "w")

    for line in lines
        println(outFile, line)
    end

    close(outFile)
end

main()
