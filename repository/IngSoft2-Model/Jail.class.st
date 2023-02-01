Class {
	#name : #Jail,
	#superclass : #Effect,
	#category : #'IngSoft2-Model'
}

{ #category : #'effect-application' }
Jail >> applyTo: aGame triggeredBy: aPlayer [

	aGame applyJailTo: aPlayer
]
