Class {
	#name : #LoadedDie,
	#superclass : #Object,
	#instVars : [
		'rollValue'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
LoadedDie class >> rolling: anExpectedRoll [

	(anExpectedRoll isNumber) ifTrue: [self validate: anExpectedRoll ].
	^ self new initializeWith: anExpectedRoll
]

{ #category : #validation }
LoadedDie class >> validate: anExpectedRoll [

	self validateLoadedDieCannotHaveNegativeResult: anExpectedRoll

]

{ #category : #validation }
LoadedDie class >> validateLoadedDieCannotHaveNegativeResult: anExpectedRoll [

	anExpectedRoll negative
		ifTrue: [ Error signal: 'A loaded die cannot have a negative result' ]
]

{ #category : #initialization }
LoadedDie >> initializeWith: anExpectedRoll [

	anExpectedRoll isNumber
		ifTrue: [ rollValue := anExpectedRoll. ]
		ifFalse: [ rollValue := OrderedCollection new.
			anExpectedRoll do: [:value | rollValue add: value  ] ]
		
	
	
	
]

{ #category : #rolling }
LoadedDie >> roll [

	| roll |
	rollValue isCollection
		ifTrue: [ 
			roll := rollValue at: 1.
			rollValue remove: roll.
			rollValue add: roll ]
		ifFalse: [ roll := rollValue ].
	^ roll
]

{ #category : #rolling }
LoadedDie >> sides [

	| sides |
	rollValue isCollection
		ifTrue: [ sides := rollValue max ]
		ifFalse: [ sides := rollValue ].
	^ sides
]
