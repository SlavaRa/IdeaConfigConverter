package converter.pom {
	import converter.Iml;

	import flash.utils.Dictionary;

	public class RootPom extends BasePom implements IPom {

		[Embed(source="/../resources/root/pom.xml", mimeType="application/octet-stream")]
		private static const POM_LIB_DATA : Class;
		private static const POM_LIB_XML : XML = XML(new POM_LIB_DATA);

		private var _pomPacks : Vector.<Dictionary>;

		public function RootPom(iml : Iml, pomPacks : Vector.<Dictionary>) {
			super(iml);
			_pomPacks = pomPacks;
		}

		override public function getXML() : XML {
			var template : String = POM_LIB_XML.toXMLString();
//			template=template.replace("${flex.framework.version}", getFullSDKVersion(iml.sdkVersion));
//			template=template.replace("${flash.player.version}", iml.flashPlayerVersion);
//			template=template.replace("${artifactId}", iml.name);
			var result : XML = XML(template);
			for each(var poms : * in _pomPacks) {
				for each(var pom : IPom in poms) {
					result.modules.module += <module>{pom.iml.relativeDirectoryPath}</module>;
				}
			}
			return result;

		}
	}
}
