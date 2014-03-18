package converter.pom {
	import converter.FileHelper;
	import converter.dom.Module;
	import converter.dom.Project;

	import flash.filesystem.File;
	import flash.utils.Dictionary;

	public class PomConverter {

		public function convertAndSave(project : Project) : void {
			//LibCreator.createLibrary(project);
			saveProjectPoms(project);
		}

		private function saveProjectPoms(project : Project) : void {
			var skipModules:Array = project.moduleRoots.findRoot(project.directory).skipModules;
			var swcs : Dictionary = new Dictionary();
			var swfs : Dictionary = new Dictionary();
			for each(var module : Module in project.modules) {
				if (isSupported(module) && skipModules.indexOf(module.name) < 0) {
					if (module.outputType == Module.OUTPUT_TYPE_LIBRARY) {
						swcs[module] = new LibPom(project, module);
					} else {
						swfs[module] = new AppPom(project, module);
						//log(this, "unknown output type: " + module.outputType);
					}
				}
			}
			savePoms([new RootPom(project, new <Dictionary>[swcs, swfs]), new ModuleListPom(project, new <Dictionary>[swcs, swfs])]);
			savePoms(swcs);
			savePoms(swfs);
		}

		private function isSupported(module : Module) : Boolean {
			if (module.moduleType != "Flex") {
				log(this, "not a flex module: " + module.name);
				return false;
			}
//			if (module.flashPlayerVersion == "11.5") {
//				log(this, "unsupported FP(" + module.flashPlayerVersion + ") in: " + module.name);
//				return false;
//			}
//			if (module.targetPlatform != Module.TARGET_PLATFORM_DESKTOP) {
//				log(this, "unsupported TargetPlatform(" + module.targetPlatform + ") in: " + module.name);
//				return false;
//			}
			return true;
		}

		private function savePoms(poms : *) : void {
			for each(var pom : IPom in poms) {
				var file : File = new File(pom.getFilePath());
				FileHelper.writeFile(file, pom.data);
			}
		}
	}
}