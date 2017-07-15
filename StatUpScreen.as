package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class StatUpScreen extends MovieClip {
		
		var characterHealth: Number;
		var characterAttack: Number;
		var characterDefend: Number;
		var characterExperience: Number;
		var characterStatPoints: Number;
		var characterStats:Dictionary;
		
		public function StatUpScreen(_docClass:Main, _characterStats:Dictionary) {
		
			this.characterStats = _characterStats;
			
			healthUp.addEventListener(MouseEvent.CLICK, IncreaseHealth);
			defendUp.addEventListener(MouseEvent.CLICK, IncreaseDefend);
			attackUp.addEventListener(MouseEvent.CLICK, IncreaseAttack);
			this.addEventListener(Event.ENTER_FRAME, update);
			
			characterHealth = characterStats["characterHealth"];
			characterAttack = characterStats["characterAttack"];
			characterDefend = characterStats["characterDefend"];
			characterExperience = characterStats["characterExperience"];
			
			trace("IN SKILLS: " + characterStats["characterExperience"]);
			
			//Constructor Code
		}
		
		function update(e:Event) {
			
			statPoints.text = "Stat Points:" + characterExperience.toString();
			attacklvl.text = characterAttack.toString();
			attacknextlevel.text = (characterAttack + 10).toString();
			defendlvl.text = characterDefend.toString();
			defendnextlevel.text = (characterDefend + 10).toString();
			healthlvl.text = characterHealth.toString();
			healthnextlevel.text = (characterHealth + 10).toString();
		}
		
		function IncreaseAttack (e:Event) {
			
			if (characterExperience > 0) {
				
				characterAttack += 10;
				characterExperience -= 10;
			}
		}
		
		function IncreaseDefend (e:Event) {

			if (characterExperience > 0) {
			
				characterDefend += 0.5;
				characterExperience -= 10;
				
			}
		}
		
		function IncreaseHealth (e:Event) {
			
			if (characterExperience > 0) {
				
				characterHealth += 10;
				characterExperience -= 10;
			}
		}
		
		public function getCharacterStats():Dictionary {
			
			characterStats["characterHealth"] = characterHealth;
			characterStats["characterAttack"] = characterAttack;
			characterStats["characterDefend"] = characterDefend;
			characterStats["characterExperience"] = characterExperience;
			
			return characterStats;
		}
		
		public function removeListeners() {
			
			healthUp.removeEventListener(MouseEvent.CLICK, IncreaseHealth);
			defendUp.removeEventListener(MouseEvent.CLICK, IncreaseDefend);
			attackUp.removeEventListener(MouseEvent.CLICK, IncreaseAttack);
			this.removeEventListener(Event.ENTER_FRAME, update);
		}
	}
}

		