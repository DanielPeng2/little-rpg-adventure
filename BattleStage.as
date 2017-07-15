package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.Dictionary;

	public class BattleStage extends MovieClip {
		
		//DETERMINE ENEMY TYPE
		private var enemyType: String;
		
		//DEFINE CLASSES
		var character:Character;
		var rat:Rat;
		var ogre:Ogre;
		var skeleton:Skeleton;
		var deathlord:DeathLord;
		
		//CHARACTER BATTLE STATS
		var characterHealth: Number;
		var characterAttack: Number;
		var characterSpeed: Number;
		var characterDefend: Number;
		
		//CHARACTER DEFENSE ADDING
		var characterDefendAdd: Number = 1;
		var characterDefendAdded: Boolean = false;
		
		//ENEMY BATTLE STATS
		var enemyHealth: Number;
		var enemyAttack: Number;
		var enemySpeed: Number;
		var enemyDefend: Number;
		
		//ENEMY DEFENSE ADDING
		var enemyDefendAdd: Number = 3;
		var enemyDefendAdded: Boolean = false;
		
		//CHARACTER EXPERIENCE
		var characterExperience: Number;
		
		//DETERMINE YOUR TURN OR NOT
		var yourTurn: Boolean;
		
		//TURN TIMER
		private var timer: Timer;
		
		//KEEP CHARACTER STATS OUTSIDE BATTLE
		var characterStats = new Dictionary();
		
		//DETERMINE IF CHARACTER IN CAVE OR NOT
		var caveArea:Boolean = false;
		
		// STORES REFERENCE TO THE MAIN CLASS
		private var docClass:Main;

		public function BattleStage(_enemyType: String, _docClass:Main, _characterStats:Dictionary, _caveArea:Boolean) {
			// constructor code
			
			this.characterStats = _characterStats;
			this.caveArea = _caveArea;
			this.docClass = _docClass;
			
			//SUMMON CAVE BACKGROUND
			if (caveArea == false) {
				
				battleCave.visible = false;
				
			} else {
				
				battleCave.visible = true;
			}
			
			// SPAWN A NEW CHARACTER
			character = new Character();
			
			//CHARACTER POSITIONING AND SIZE
			character.x = 250;
			character.y = 925;
			character.scaleX = -4;
			character.scaleY = 4;
			
			//SPAWN IN CHARACTER
			this.addChild(character);
			
			//GO TO IDLE LEFT ANIMATION
			character.gotoAndStop("IdleLeft");
			
			//DISPLAY CHARACTER HEALTH
			characterHealthText.text = "Character health: " + characterStats["characterHealth"];

			//DETERMINE ENEMYTYPE
			this.enemyType = _enemyType;

			// IF THE ENEMY YOU RAN INTO IS RAT, SPAWN A RAT AND ASSIGN STATS ACCORDINGLY
			if (enemyType == "rat") {

				rat = new Rat();
				
				//RAT POSITIONING AND SIZE
				rat.x = 775;
				rat.y = 925;
				rat.scaleX = 4;
				rat.scaleY = 4;
				
				//SPAWN IN RAT
				this.addChild(rat);
				
				//GO TO IDLE LEFT ANIMATION
				rat.gotoAndStop("IdleLeft");
				
				//ENEMY BATTLE STATS
				enemyHealth = 20;
				enemyAttack = 5;
				enemyDefend = 1;
				enemySpeed = 7;
				
				//DISPLAY ENEMY HEALTH TEXT
				enemyHealthText.text = "Enemy health: " + enemyHealth;
			}

			if (enemyType == "ogre") {

				ogre = new Ogre();
				
				//OGRE SIZE AND POSITIONING
				ogre.x = 775;
				ogre.y = 925;
				ogre.scaleX = 4;
				ogre.scaleY = 4;
				
				//SPAWN IN OGRE
				this.addChild(ogre);
				
				//GO TO IDLE LEFT ANIMATION
				ogre.gotoAndStop("IdleLeft");
				
				//ENEMY BATTLE STATS
				enemyHealth = 100;
				enemyAttack = 3;
				enemyDefend = 2;
				enemySpeed = 3;
				
				//DISPLAY ENEMY HEALTH TEXT
				enemyHealthText.text = "Enemy health: " + enemyHealth;
			}
			
			if (enemyType == "skeleton") { 
				
				skeleton = new Skeleton();
				
				//SKELETON SIZE AND POSITIONING
				skeleton.x = 775;
				skeleton.y = 925;
				skeleton.scaleX = 4;
				skeleton.scaleY = 4;
				
				//SPAWN IN SKELETON
				this.addChild(skeleton);
				
				//GO TO IDLE LEFT ANIMATION
				skeleton.gotoAndStop("IdleLeft");
				
				//ENEMY BATTLE STATS
				enemyHealth = 100;
				enemyAttack = 7;
				enemyDefend = 3;
				enemySpeed = 5;
				
				//DISPLAY ENEMY HEALTH TEXT
				enemyHealthText.text = "Enemy health: " + enemyHealth;
			}
			
			if (enemyType == "deathlord") {
				
				deathlord = new DeathLord();
				
				//DEATHLORD SIZE AND POSITIONING
				deathlord.x = 775;
				deathlord.y = 925;
				deathlord.scaleX = 5;
				deathlord.scaleY = 5;
				
				//SPAWN IN DEATHLORD
				this.addChild(deathlord);
				
				//GO TO IDLE LEFT ANIMATION
				deathlord.gotoAndStop("IdleLeft");
				
				//ENEMY BATTLE STATS
				enemyHealth = 200;
				enemyAttack = 10;
				enemyDefend = 3;
				enemySpeed = 5;
				
				//DISPLAY ENEMY HEALTH TEXT
				enemyHealthText.text = "Enemy health: " + enemyHealth;
			}
				
			//COMPARISON OF SPEED TO DETERMINE FIRST TURN
			if (characterStats["characterSpeed"] >= enemySpeed) {

				yourTurn = true;
			
			} else {

				yourTurn = false;
			}
		}

		public function update() {
			
			//IF RAT ATTACK ANIMATION ENDS, GO TO IDLE ANIMATION
			if (enemyType == "rat") {
			
				if (rat.currentLabel == "AttackLeft") {
					
					if (rat.RatAttackLeft.currentFrame == 9) {
						
						rat.gotoAndStop("IdleLeft");
					}
				}
			}
			
			//IF OGRE ATTACK ANIMATION ENDS, GO TO IDLE ANIMATION
			if (enemyType == "ogre") {
				
				if (ogre.currentLabel == "AttackLeft") {
					
					if (ogre.OgreAttackLeft.currentFrame == 9) {
						
						ogre.gotoAndStop("IdleLeft");
					}
				}
			}
			
			//IF SKELETON ATTACK ANIMATION ENDS, GO TO IDLE ANIMATION
			if (enemyType == "skeleton") {
				
				if (skeleton.currentLabel == "AttackLeft") {
					
					if (skeleton.SkeletonAttackLeft.currentFrame == 9) {
						
						skeleton.gotoAndStop("IdleLeft");
					}
				}
			}
			
			//IF DEATHLORD ATTACK ANIMATION ENDS, GO TO IDLE ANIMATION
			if (enemyType == "deathlord") {
				
				if (deathlord.currentLabel == "AttackLeft") {
					
					if (deathlord.DeathlordAttackLeft.currentFrame == 15) {
						
						deathlord.gotoAndStop("IdleLeft");
					}
				}
			}
			
			//IF CHARACTER ATTACK ANIMATION ENDS, GO TO IDLE ANIMATION
			if (character.currentLabel == "AttackLeft") {
				
				if (character.CharacterAttackLeft.currentFrame == 10) {
					
					character.gotoAndStop("IdleLeft");
				}
			}
			
			//IF ENEMY DIES, GO BACK TO MAIN WORLD
			if (characterStats["characterHealth"] <= 0 || enemyHealth <= 0) {
				
				//REMOVE EVENT LISTENERS
				attackButton.removeEventListener(MouseEvent.CLICK, characterAttackTurn);
				defendButton.removeEventListener(MouseEvent.CLICK, characterDefendTurn);
				itemButton.removeEventListener(MouseEvent.CLICK, characterItemTurn);
				runAwayButton.removeEventListener(MouseEvent.CLICK, characterRunAwayTurn);
				
				//ADD EXPERIENCE BASED ON ENEMY
				if (enemyType == "rat") {
					
					characterStats["characterExperience"] += 10;
				}
				
				if (enemyType == "ogre") {
					
					characterStats["characterExperience"] += 20;
				}
				
				if (enemyType == "skeleton") {
					
					characterStats["characterExperience"] += 30;
				}
				
				//REMOVE TIMER
				if (timer != null) {
				
					timer.removeEventListener("timer", enemyStart);
				}
				
				if (characterStats["characterHealth"] <= 0 && enemyHealth > 0) {
					
					docClass.removeBattleScene(characterStats, true, false);
				}
				
				if (characterStats["characterHealth"] > 0 && enemyHealth <= 0 && enemyType != "deathlord") {
					
					docClass.removeBattleScene(characterStats, false, false);
				}
				
				if (characterStats["characterHealth"] > 0 && enemyHealth < 0 && enemyType == "deathlord") {
					
					docClass.removeBattleScene(characterStats, false, true);
				}
				return;
			}

			//START YOUR TURN WITHOUT REDUCING BONUS DEFEND
			if (yourTurn == true && characterDefendAdded == false) {

				//YOUR TURN NOTIFICATION
				turnText.text = "Your turn";

				//ADD EVENT LISTENERS TO BUTTONS
				attackButton.addEventListener(MouseEvent.CLICK, characterAttackTurn);
				defendButton.addEventListener(MouseEvent.CLICK, characterDefendTurn);
				itemButton.addEventListener(MouseEvent.CLICK, characterItemTurn);
				runAwayButton.addEventListener(MouseEvent.CLICK, characterRunAwayTurn);
			}
			
			//START YOUR TURN WHILE REDUCING BONUS DEFEND
			if (yourTurn == true && characterDefendAdded == true) {
				
				//REMOVE BONUS DEFEND
				characterStats["characterDefend"] = characterStats["characterDefend"] - characterDefendAdd;
				characterDefendAdded = false;

				//YOUR TURN NOTIFICATION
				turnText.text = "Your turn";
				
				//ADD EVENT LISTENERS TO BUTTONS
				attackButton.addEventListener(MouseEvent.CLICK, characterAttackTurn);
				defendButton.addEventListener(MouseEvent.CLICK, characterDefendTurn);
				itemButton.addEventListener(MouseEvent.CLICK, characterItemTurn);
				runAwayButton.addEventListener(MouseEvent.CLICK, characterRunAwayTurn);
				
			}
			
			//START ENEMY TURN
			if (yourTurn == false) {

				//REMOVE EVENT LISTENERS TO BUTTONS
				attackButton.removeEventListener(MouseEvent.CLICK, characterAttackTurn);
				defendButton.removeEventListener(MouseEvent.CLICK, characterDefendTurn);
				itemButton.removeEventListener(MouseEvent.CLICK, characterItemTurn);
				runAwayButton.removeEventListener(MouseEvent.CLICK, characterRunAwayTurn);
				
				//ENEMY TURN NOTIFICATION
				turnText.text = "Enemy turn";
				
				//ENEMY TURN TIMER
				if (timer == null) {
					timer = new Timer(1500, 0);
					
					//ENEMY TURN
					timer.addEventListener("timer", enemyStart);
					timer.start();
				}
			}
		}

		function enemyStart(e: Event) {
			
			//REMOVE TIMER
			timer.removeEventListener("timer", enemyStart);
			
			//REMOVE BONUS ARMOUR
			if (enemyDefendAdded == true) {
				enemyDefend -= enemyDefendAdd;
				enemyDefendAdded = false;
				
				//GENERATE RANDOM NUMBER
				var enemyTurn = Math.random();
			
				//ENEMY ATTACK
				if (enemyTurn > 0.3) {
					
					//GENERATE RANDOM DODGE CHANCE
					var characterDodge = Math.random();
					
					//CRITICAL HIT ATTACK
					if (characterDodge > 0.90) {
						
						//GO TO ATTACK ANIMATION
						if (enemyType == "rat") {
							rat.gotoAndStop("AttackLeft");
						}
						if (enemyType == "ogre") {
							ogre.gotoAndStop("AttackLeft");
						}
						if (enemyType == "skeleton") {
							skeleton.gotoAndStop("AttackLeft");
						}
						if (enemyType == "deathlord") {
							deathlord.gotoAndStop("AttackLeft");
						}
						
						//DEAL DOUBLE DAMAGE
						characterStats["characterHealth"] -= Math.round((enemyAttack / characterStats["characterDefend"])*2);
						
						//DISPLAY DAMAGE
						characterHealthText.text = "Character health: " + characterStats["characterHealth"];
						consoleText.text = "Critical hit! You took " + Math.round((enemyAttack / characterStats["characterDefend"])*2) + " damage from the " + enemyType + "!";
						
						//SET TO YOUR TURN
						yourTurn = true;
						timer = null;
					}
					
					//ATTACK
					if (characterDodge > 0.10 && characterDodge < 0.90) {
						
						//GO TO ATTACK ANIMATION
						if (enemyType == "rat") {
							rat.gotoAndStop("AttackLeft");
						}
						if (enemyType == "ogre") {
							ogre.gotoAndStop("AttackLeft");
						}
						if (enemyType == "skeleton") {
							skeleton.gotoAndStop("AttackLeft");
						}
						if (enemyType == "deathlord") {
							deathlord.gotoAndStop("AttackLeft");
						}
						
						//DEAL DAMAGE
						characterStats["characterHealth"] -= Math.round(enemyAttack / characterStats["characterDefend"]);
						
						//DISPLAY DAMAGE
						characterHealthText.text = "Character health: " + characterStats["characterHealth"];
						consoleText.text = "You took " + Math.round(enemyAttack / characterStats["characterDefend"]) + " damage from the " + enemyType + "!";
						
						//SET TO YOUR TURN
						yourTurn = true;
						timer = null;
					}
					
					//DODGE ATTACK
					if (characterDodge < 0.10) {
						
						consoleText.text = "You dodged the " + enemyType + "'s attack!";
						yourTurn = true;
						timer = null
					}
				}
				
				//ENEMY DEFEND
				if (enemyTurn < 0.3) {
					
					//ADD BONUS ARMOUR
					enemyDefend += enemyDefendAdd;
					
					//DISPLAY DEFEND STATUS
					consoleText.text = "The " + enemyType + " braces itself for an attack.";
					
					//SET BONUS ARMOUR GIVEN TO TRUE
					enemyDefendAdded = true;
					
					//SET TO YOUR TURN
					yourTurn = true;
					timer = null;
				}
				
			} else {
				
				enemyTurn = Math.random();
			
				if (enemyTurn > 0.3) {
					
					characterDodge = Math.random();
					
					if (characterDodge > 0.90) {
						
						if (enemyType == "rat") {
							rat.gotoAndStop("AttackLeft");
						}
						if (enemyType == "ogre") {
							ogre.gotoAndStop("AttackLeft");
						}
						if (enemyType == "skeleton") {
							skeleton.gotoAndStop("AttackLeft");
						}
						if (enemyType == "deathlord") {
							deathlord.gotoAndStop("AttackLeft");
						}
						characterStats["characterHealth"] -= Math.round((enemyAttack / characterStats["characterDefend"])*2);
						characterHealthText.text = "Character health: " + characterStats["characterHealth"];
						consoleText.text = "Critical hit! You took " + Math.round((enemyAttack / characterStats["characterDefend"])*2) + " damage from the " + enemyType + "!";
						yourTurn = true;
						timer = null;
					}
					if (characterDodge > 0.10 && characterDodge < 0.90) {
						
						if (enemyType == "rat") {
							rat.gotoAndStop("AttackLeft");
						}
						if (enemyType == "ogre") {
							ogre.gotoAndStop("AttackLeft");
						}
						if (enemyType == "skeleton") {
							skeleton.gotoAndStop("AttackLeft");
						}
						if (enemyType == "deathlord") {
							deathlord.gotoAndStop("AttackLeft");
						}
						characterStats["characterHealth"] -= Math.round(enemyAttack / characterStats["characterDefend"]);
						characterHealthText.text = "Character health: " + characterStats["characterHealth"];
						consoleText.text = "You took " + Math.round(enemyAttack / characterStats["characterDefend"]) + " damage from the " + enemyType + "!";
						yourTurn = true;
						timer = null;
					}
					if (characterDodge < 0.10) {
						
						consoleText.text = "You dodged the " + enemyType + "'s attack!";
						yourTurn = true;
						timer = null
					}
				}
				
				if (enemyTurn < 0.3) {
					
					enemyDefend += enemyDefendAdd;
					consoleText.text = "The " + enemyType + " braces itself for an attack.";
					enemyDefendAdded = true;
					yourTurn = true;
					timer = null;
				}	
			}
			
			
		}

		function characterAttackTurn(e: Event) {

			var enemyDodge = Math.random();

			if (enemyDodge > 0.90) {
				
				character.gotoAndStop("AttackLeft");
				enemyHealth -= Math.round((characterStats["characterAttack"] / enemyDefend) * 2);
				enemyHealthText.text = "Enemy health: " + enemyHealth;
				consoleText.text = "Critical hit! You dealt " + Math.round((characterStats["characterAttack"] / enemyDefend) * 2) + " damage to the " + enemyType + "!";
				yourTurn = false;
			}

			if (enemyDodge > 0.10 && enemyDodge < 0.90) {
				
				character.gotoAndStop("AttackLeft");
				enemyHealth -= Math.round(characterStats["characterAttack"] / enemyDefend);
				enemyHealthText.text = "Enemy health: " + enemyHealth;
				consoleText.text = "You dealt " + Math.round(characterStats["characterAttack"] / enemyDefend) + " damage to the " + enemyType + "!";
				yourTurn = false;
			}

			if (enemyDodge < 0.10) {

				consoleText.text = "The " + enemyType + " dodged your attack!";
				yourTurn = false;
			}
		}

		function characterDefendTurn(e: Event) {
			
			characterStats["characterDefend"] += characterDefendAdd;
			consoleText.text = "You brace yourself for an attack.";
			characterDefendAdded = true;
			yourTurn = false;
		}

		function characterItemTurn(e: Event) {

		}

		function characterRunAwayTurn(e: Event) {
			
			if (enemyType != "deathlord") {
				
				trace("Run: " + enemyType);
			
				var runAwayChance = Math.random();
				
				if (characterStats["characterSpeed"] == enemySpeed) {
					
					if (runAwayChance < 0.5) {
						
						consoleText.text = "Can't escape!";
						trace("Can't escape!");
						yourTurn = false;
					}
					
					if (runAwayChance > 0.5) {
				
						trace("escape");
						attackButton.removeEventListener(MouseEvent.CLICK, characterAttackTurn);
						defendButton.removeEventListener(MouseEvent.CLICK, characterDefendTurn);
						itemButton.removeEventListener(MouseEvent.CLICK, characterItemTurn);
						runAwayButton.removeEventListener(MouseEvent.CLICK, characterRunAwayTurn);
							
						if (timer != null) {
							
							timer.removeEventListener("timer", enemyStart);
						}
							
						docClass.removeBattleScene(characterStats, false, false);
						return;
					}
				}
				
				if (characterStats["characterSpeed"] > enemySpeed) {
					
					if (runAwayChance < 0.2) {
						
						consoleText.text = "Can't escape!";
						yourTurn = false;
					}
					
					if (runAwayChance > 0.2) {
				
						attackButton.removeEventListener(MouseEvent.CLICK, characterAttackTurn);
						defendButton.removeEventListener(MouseEvent.CLICK, characterDefendTurn);
						itemButton.removeEventListener(MouseEvent.CLICK, characterItemTurn);
						runAwayButton.removeEventListener(MouseEvent.CLICK, characterRunAwayTurn);
							
						if (timer != null) {
							
							timer.removeEventListener("timer", enemyStart);
						}
							
						docClass.removeBattleScene(characterStats, false, false);
						return;
					}
				}
				
				if (characterStats["characterSpeed"] < enemySpeed) {
					
					if (runAwayChance > 0.2) {
						
						consoleText.text = "Can't escape!";
						yourTurn = false;
					}
					
					if (runAwayChance < 0.2) {
				
						attackButton.removeEventListener(MouseEvent.CLICK, characterAttackTurn);
						defendButton.removeEventListener(MouseEvent.CLICK, characterDefendTurn);
						itemButton.removeEventListener(MouseEvent.CLICK, characterItemTurn);
						runAwayButton.removeEventListener(MouseEvent.CLICK, characterRunAwayTurn);
							
						if (timer != null) {
							
							timer.removeEventListener("timer", enemyStart);
						}
							
						docClass.removeBattleScene(characterStats, false, false);
						return;
					}
				}
			}
		}
	}
}