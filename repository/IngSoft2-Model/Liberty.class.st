Class {
	#name : #Liberty,
	#superclass : #Instant,
	#category : #'IngSoft2-Model'
}

{ #category : #'card - effect applications' }
Liberty >> applyOn: aGame to: aPlayer [

	aGame removeFromJail: aPlayer
]

{ #category : #'private - validations' }
Liberty >> playableBy: aPlayer on: aGame affecting: target [
	
	( aGame isInJail: aPlayer ) ifFalse: [ Error signal: 'Cant use card if player is not in jail' ]
	
]
