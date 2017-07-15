package {

	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.display.Graphics;
	import flash.filters.GradientBevelFilter;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	public class Character extends MovieClip {

		private var left: Boolean = false;
		private var right: Boolean = false;
		private var up: Boolean = false;
		private var down: Boolean = false;
		private var speed: int = 5;
		private var idleDirection: String = "IdleDown";
		private var mapDirection: String;
		private var enemies: Array;
		private var enemyHit: Boolean = false;
		private var leftClear: Boolean = true;
		private var rightClear: Boolean = true;
		private var upClear: Boolean = true;
		private var downClear: Boolean = true;
		private var obstaclesArray:Array;
		public var hitTestError: int = 2;
		private var leftLine: Rectangle;
		private var rightLine: Rectangle;
		private var upLine: Rectangle;
		private var downLine: Rectangle;
		private var testLeftLine: Sprite;
		private var main: Main;
		private var enemy;
		public var enemyType: String = null;
		var count = 0;
		private var caveEntered = false;
		private var leftClearFound:Boolean = false;
		private var rightClearFound:Boolean = false;
		private var downClearFound:Boolean = false;
		private var upClearFound:Boolean = false;
		private var headClearFound:Boolean = false;
		private var objectTouched:Object;
		private var secondObjectTouched:Boolean = false;

		public function Character(enemiesArray: Array = null, docClass: Main = null) {
			
			this.enemies = enemiesArray;
			this.main = docClass;
			// ADDS A CONSTRUCTOR THAT IS CALLED WHEN THE CHARACTER IS ADDED TO THE STAGE
			this.addEventListener(Event.ADDED_TO_STAGE, constructorFunc);
		}
	
		// ADDED TO STAGE CONSTRUCTOR
		private function constructorFunc(e: Event) {

			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		public function update() {
			
			// CHECKS IF YOU HIT AN ENEMY
			for (var i = 0; i < enemies.length; i++) {
			
				if (enemies[i] != null) {
					
					if (this.hitTestObject(enemies[i])) {

						enemy = enemies[i];
						enemyHit = true;
						if (enemies[i] is Rat) {
							enemyType = "rat";
						}
						if (enemies[i] is Ogre) {
							enemyType = "ogre";
						}
						if (enemies[i] is Skeleton) {
							enemyType = "skeleton";
						}
						if (enemies[i] is DeathLord) {
							enemyType = "deathlord";
						}
						return;
					}
				}
			}
			
			
			hitDetection();
			
			
			// ANIMATE THE CHARACTER SO IT LOOKS LIKE HE'S WALKING
			// THE LAST DIRECTION YOU WERE WALKING IN IS ALSO STORED SO THAT THE CHARACTER IDLES IN THAT DIRECTION
			if (left == true || right == true) {

				if (left == true && leftClear == true) {

					this.gotoAndStop("WalkLeft");
					idleDirection = "IdleLeft";
					mapDirection = "Right";
				}

				if (left == true && leftClear == false) {

					idleDirection = "IdleLeft"
					mapDirection = null;
				}

				if (right == true && rightClear == true) {

					this.gotoAndStop("WalkRight");
					idleDirection = "IdleRight";
					mapDirection = "Left";
				}

				if (right == true && rightClear == false) {

					idleDirection = "IdleRight";
					mapDirection = null;
				}
			} else if (up == true || down == true) {

				if (up == true && upClear == true) {

					this.gotoAndStop("WalkUp");
					idleDirection = "IdleUp";
					mapDirection = "Down";
				}

				if (up == true && upClear == false) {

					idleDirection = "IdleUp";
					mapDirection = null;
				}

				if (down == true && downClear == true) {

					this.gotoAndStop("WalkDown");
					idleDirection = "IdleDown";
					mapDirection = "Up";
				}

				if (down == true && downClear == false) {

					idleDirection = "IdleDown";
					mapDirection = null;
				}
			} else {

				this.gotoAndStop(idleDirection);
				mapDirection = null;
			}
		}
		
		// KEY LISTENERS
		private function keyDownHandler(k: KeyboardEvent) {

			if (k.keyCode == Keyboard.LEFT) {

				left = true;
			}

			if (k.keyCode == Keyboard.RIGHT) {

				right = true;
			}

			if (k.keyCode == Keyboard.UP) {

				up = true;
			}

			if (k.keyCode == Keyboard.DOWN) {

				down = true;
			}
			if (k.keyCode == Keyboard.SHIFT) {

				speed = 8;
			}
		}

		private function keyUpHandler(k: KeyboardEvent) {

			if (k.keyCode == Keyboard.LEFT) {

				left = false;
			}

			if (k.keyCode == Keyboard.RIGHT) {

				right = false;
			}

			if (k.keyCode == Keyboard.UP) {

				up = false;
			}

			if (k.keyCode == Keyboard.DOWN) {

				down = false;
			}
			if (k.keyCode == Keyboard.SHIFT) {

				speed = 5;
			}
		}

		// SAME HIT DETECTION SYSTEM USED IN THE CHARACTERS
		// THIS TIME I CHECK EVERY OBSTACLE, NOT JUST ALL OF THEM UNTIL I FIND ONE YOUR TOUCHING (NO RETURN STATEMENT)
		private function hitDetection() {

			leftClearFound = false;
			rightClearFound = false;
			upClearFound = false;
			downClearFound = false;
			headClearFound = false;
			objectTouched = null;
			secondObjectTouched = false;
			
			for (var i = 0; i < obstaclesArray.length; i++) {

				var currentHitTestObject = obstaclesArray[i];
					
				if (currentHitTestObject != null) {
					
					var currentHitTestBoundsMC = currentHitTestObject.hitTestSquare;
					
					if (currentHitTestBoundsMC != undefined) {
						
						if (this.hitTestObject(currentHitTestBoundsMC) == true) {

							objectTouched = currentHitTestObject;
							
							if (currentHitTestObject.name == "caveDoor" || currentHitTestObject.name == "caveDoorInstance") {
						
								caveEntered = true;
								
								return;
							}
							
							if (currentHitTestBoundsMC.hitTestPoint(this.x - this.width / 2, this.y - this.height / 6, true) || currentHitTestBoundsMC.hitTestPoint(this.x - this.width / 2, this.y, true)) {

								leftClear = false;
								
								leftClearFound = true;
							}

							if (currentHitTestBoundsMC.hitTestPoint(this.x + this.width / 2, this.y - this.height / 6, true) || currentHitTestBoundsMC.hitTestPoint(this.x + this.width / 2, this.y, true)) {

								rightClear = false;
								
								rightClearFound = true;
							}

							if (currentHitTestBoundsMC.hitTestPoint(this.x, this.y - this.height / 3, true)) {

								upClear = false;
								
								upClearFound = true;
							}

							if (currentHitTestBoundsMC.hitTestPoint(this.x, this.y, true)) {

								downClear = false;
								
								downClearFound = true;
							}
						} 
						
						else if (this.hitTestObject(currentHitTestBoundsMC) == false) {

							if (!currentHitTestBoundsMC.hitTestPoint(this.x - this.width / 2, this.y - this.height / 2, true) || currentHitTestBoundsMC.hitTestPoint(this.x - this.width / 2, this.y - this.height, true) || currentHitTestBoundsMC.hitTestPoint(this.x - this.width / 2, this.y + this.height, true)) {

								if (leftClearFound == false) {
									
									leftClear = true;
								}
							}

							if (!currentHitTestBoundsMC.hitTestPoint(this.x + this.width / 2, this.y - this.height / 2, true) || currentHitTestBoundsMC.hitTestPoint(this.x + this.width / 2, this.y - this.height, true) || currentHitTestBoundsMC.hitTestPoint(this.x + this.width / 2, this.y + this.height, true)) {

								if (rightClearFound == false) {
									
									rightClear = true;
								}
							}

							if (!currentHitTestBoundsMC.hitTestPoint(this.x, this.y - this.height / 3, true)) {

								if (upClearFound == false) {	
								
									upClear = true;
								}
							}

							if (!currentHitTestBoundsMC.hitTestPoint(this.x, this.y, true)) {
								
								if (downClearFound == false) {
									
									downClear = true;
								}
							}
						}
					}
				}
			}
		}

		// ALL THESE FUNCTIONS ARE USED BY THE MAIN CLASS TO GET AND SET VALUES
		public function getMapDirection(): String {

			return mapDirection;
		}

		public function getSpeed(): int {

			return speed;
		}

		public function getEnemyHit(): Boolean {

			return enemyHit;
		}
		
		public function getEnemy():Object {
			
			return enemy;
		}
		
		public function resetEnemyHit() {
			
			enemyHit = false;
		}

		public function setObstaclesArray(_obstaclesArray:Array) {

			this.obstaclesArray = _obstaclesArray;
		}

		public function getEnemyType(): String {

			return enemyType;
		}
		
		public function setEnemyArray(_enemies:Array) {
			
			this.enemies = _enemies;
		}
		
		public function getCaveEntered():Boolean {
			
			return this.caveEntered;
		}
		
		public function setCaveEntered(caveValue:Boolean) {
			
			this.caveEntered = caveValue;
		}
	}
}