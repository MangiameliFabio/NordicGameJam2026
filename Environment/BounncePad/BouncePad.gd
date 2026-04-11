class_name BouncePad extends Node3D

func BulletEntered(bullet: Bullet) -> void:
	var pad_normal: Vector3 = global_transform.basis.z.normalized()
	var incoming: Vector3 = bullet._velocity

	if incoming.dot(pad_normal) < 0.0:
		bullet._velocity = incoming.bounce(pad_normal)
	
