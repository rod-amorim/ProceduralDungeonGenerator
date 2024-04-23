@tool
extends Node3D

class_name WorldCell2

@export var TopFace: MeshInstance3D
@export var BottomFace: MeshInstance3D

@export var LeftFace: MeshInstance3D
@export var RightFace: MeshInstance3D
@export var ForwardFace: MeshInstance3D
@export var BackFace: MeshInstance3D

@export var LeftDoorFace: MeshInstance3D
@export var RightDoorFace: MeshInstance3D
@export var ForwardDoorFace: MeshInstance3D
@export var BackDoorFace: MeshInstance3D

func RemoveWallUp():
	if BackFace:
		BackFace.free()
func RemoveWallDown():
	if ForwardFace:
		ForwardFace.free()
func RemoveWallLeft():
	if RightFace:
		RightFace.free()
func RemoveWallRight():
	if LeftFace:
		LeftFace.free()
func RemoveDoorUp():
	if BackDoorFace:
		BackDoorFace.free()
func RemoveDoorDown():
	if ForwardDoorFace:
		ForwardDoorFace.free()
func RemoveDoorLeft():
	if RightDoorFace:
		RightDoorFace.free()
func RemoveDoorRight():
	if LeftDoorFace:
		LeftDoorFace.free()
