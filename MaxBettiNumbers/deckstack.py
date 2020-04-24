import numpy

#This is payload. Essentially the computation of a single location in a convolution
def singleTarget(newPile, prevPilesMax, minPrevPileCount, prevPileCount, prevTotalCountOffset, targetTotalCount):
    maxNewPileCount     = len(newPile) - 1
    maxPrevTotalCount   = len(prevPilesMax) - 1 + prevTotalCountOffset

    newStartIndex   = max(0, targetTotalCount - maxPrevTotalCount)
    newEndIndex     = min(maxNewPileCount, targetTotalCount - prevTotalCountOffset)
    prevStartIndex  = targetTotalCount - newStartIndex - prevTotalCountOffset
    prevEndIndex    = targetTotalCount - newEndIndex - prevTotalCountOffset - len(prevPilesMax)

    stacks = newPile[newStartIndex:newEndIndex+1] + prevPilesMax[prevStartIndex:prevEndIndex-1:-1]
    valid = minPrevPileCount[newStartIndex:newEndIndex+1] <= prevPileCount[prevStartIndex:prevEndIndex-1:-1]

    validStacks = stacks * valid[:,None]

    singleNewPilesMax = validStacks.max(0)
    singleAllNewPileCount = numpy.argwhere(validStacks[:,0] == singleNewPilesMax[0]).flatten() + newStartIndex
    return singleNewPilesMax, singleAllNewPileCount

#This calls singleTarget a bunch of times. Essentially a convolution.
def allTargets(newPile, prevPilesMax, minPrevPileCount, prevPileCount, prevTotalCountOffset, minTargetTotalCount, maxTargetTotalCount):
    newPilesMax, newPileCount = [], []
    allNewPileCount = []
    for targetTotalCount in range(minTargetTotalCount, maxTargetTotalCount + 1):
        singleNewPilesMax, singleAllNewPileCount = singleTarget(newPile, prevPilesMax, minPrevPileCount, prevPileCount, prevTotalCountOffset, targetTotalCount)
        newPilesMax.append(singleNewPilesMax)
        newPileCount.append(singleAllNewPileCount.max())
        allNewPileCount.append(singleAllNewPileCount.tolist())
    return numpy.asarray(newPilesMax), numpy.asarray(newPileCount), allNewPileCount

#This calls allTargets a bunch of times. This is the main algorithm.
def getMax(allPiles, dataType):
    pilesCounts = []

    n = len(allPiles[0][0][0])
    pilesMax = numpy.zeros((1, n), dtype = dataType)
    pileCount = numpy.zeros(1, dtype = dataType)
    prevTotalCountOffset = 0;

    for newPile, minTargetTotalCount, maxTargetTotalCount, minPrevPileCount in allPiles:
        pilesMax, pileCount, allPileCount = allTargets(newPile, pilesMax, minPrevPileCount, pileCount, prevTotalCountOffset, minTargetTotalCount, maxTargetTotalCount)
        prevTotalCountOffset = minTargetTotalCount
        pilesCounts.append(allPileCount)
    return pilesMax, pilesCounts



def getStacksRecursion(pilesCounts, targetTotalCount, targetOffsets, pile, one, recursionStack):
    if pile == -1:
        result = [[]]
    else:
        result = []
        countOptions = pilesCounts[pile][targetTotalCount - targetOffsets[pile]];
        if one and countOptions:
            countOptions = [max(countOptions)]
        for c in countOptions:
            lowerStacks = getStacksRecursion(pilesCounts, targetTotalCount - c, targetOffsets, pile - 1, one, recursionStack)
            #########################################Ignore this to understand the recursion
            recursionStack.append(lowerStacks)      #This, along with the below wrapper function is to avoid a recursion limits
            lowerStacks = yield                     #This, along with the below wrapper function is to avoid a recursion limits
            #########################################Ignore this to understand the recursion
            for s in lowerStacks:
                s.append(c)
            result.extend(lowerStacks)
    yield result                                    #This can be thought of as "return result"

def getStacks(pilesCounts, targetTotalCount, targetOffsets, one = False):
    recursionStack = []
    recursionStack.append(
    #This is the wrapper function call everything else is to avoid a recurions limit.################################
        getStacksRecursion(pilesCounts, targetTotalCount, targetOffsets, len(pilesCounts) - 1, one, recursionStack) #
    #This is the wrapper function call everything else is to avoid a recurions limit.################################
    )
    prevResult = None
    while recursionStack:
        prevResult = recursionStack[-1].send(prevResult)
        if prevResult is not None:
            del recursionStack[-1]
    return prevResult


import sys,ast

dataType = int
numOutputs = 1

n = ast.literal_eval(sys.argv[1])

for arg in sys.argv[2:]:
    if arg[0] == '-':
        for c in arg:
            if c == 'd':
                dataType = None
            if c == 'o':
                dataType = 'O'
            if c == 'i':
                dataType = int
            if c == 'a':
                numOutputs = 2
            if c == 's':
                numOutputs = 1
            if c == 'n':
                numOutputs = 0

def cleanupInputLine(l):
    l = l.replace("{","[").replace("}","]")
    l = l.replace("(","[").replace(")","]")
    l = l.replace("<","[").replace(">","]")
    l = l.replace("<","[").replace(">","]")
    l = l.replace(" ","")
    l = l.replace("[,","[None,").replace(",,",",None,").replace(",,",",None,")
    return l

allPiles = []
minTarget = 0
maxTarget = 0
targetOffsets = []
for line in sys.stdin:
    pileInput = list(ast.literal_eval(cleanupInputLine(line)))
    if pileInput:
        newPile = pileInput[0]
        maxTarget = maxTarget + len(newPile)
        newMinPrevPileCount = []
        if len(pileInput) > 1:
            if pileInput[1] != None:
                minTarget = max(minTarget, pileInput[1])
            if len(pileInput) > 2:
                if pileInput[2] != None:
                    maxTarget = min(maxTarget, pileInput[2])
                if len(pileInput) > 3:
                    if pileInput[3] != None:
                        newMinPrevPileCount = pileInput[3]
        if maxTarget < minTarget:
            sys.exit()
        newPile.insert(0, [0] * n)
        newPile = numpy.cumsum(numpy.asarray(newPile, dtype = dataType), 0)
        lastNewMinPrevPileCount = 0
        if newMinPrevPileCount:
            lastNewMinPrevPileCount = newMinPrevPileCount[-1]
        newMinPrevPileCount.extend([lastNewMinPrevPileCount] * (len(newPile) - len(newMinPrevPileCount)))
        newMinPrevPileCount = numpy.asarray(newMinPrevPileCount, dtype = dataType)
        allPiles.append([newPile, minTarget, maxTarget, newMinPrevPileCount])
        targetOffsets.append(minTarget)
pilesMax, pilesCounts = getMax(allPiles, dataType)

for t in range(minTarget, maxTarget + 1):
    i = t - minTarget
    outputs = []
    if numOutputs > 0:
        outputs = getStacks(pilesCounts, t, targetOffsets, numOutputs == 1)
    print("{},{}".format(t,len(outputs)))
    print(str(list(pilesMax[i])).replace(" ",""))
    for o in outputs:
        print(str(o).replace(" ",""))
