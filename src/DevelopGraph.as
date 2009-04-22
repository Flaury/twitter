package org.un.cava.birdeye.ravis.components.renderers.nodes {
	
	import flash.events.Event;
	
	import mx.containers.Box;
	import mx.core.UIComponent;
	
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;
	import org.un.cava.birdeye.ravis.utils.events.VGraphEvent;
	
	
		
	/**
	 * This is a simple renderer, similar to the filtered circle
	 * but renders a rectangle which is rotated according to the
	 * angle of the corresponding visualNode
	 * */
	public class DevelopGraph extends EffectBaseNodeRenderer  {
		
		private static const _LOG:String = "components.renderers.nodes.RotatedRectNodeRenderer";		
		
		private var _rc:UIComponent;
		
		public var boxWidth:Number = 20;

		
		/**
		 * Default constructor
		 * */
		public function RotatedRectNodeRenderer() {
			super();
			this.addEventListener(VGraphEvent.VNODE_UPDATED,updateNode);
		}
	
		/**
		 * @inheritDoc
		 * */
		override protected function initComponent(e:Event):void {
			
			/* initialize the upper part of the renderer */
			initTopPart();
			
			/* add a primitive rectangle
			 * as well the XML should be checked before */
			
			/*
			rc = RendererIconFactory.createIcon("primitive::rectangle",
				this.data.data.@nodeSize,
				this.data.data.@nodeColor);
			*/
			_rc = new Box;
			
			_rc.width = this.data.data.@nodeSize;
			_rc.height = boxWidth; 
			
			_rc.setStyle("backgroundColor",this.data.data.@nodeColor);
			_rc.setStyle("borderStyle","solid");
			
			_rc.toolTip = this.data.data.@name; // needs check
			
			/* rotate. Note that this will only rotate on init
			 * i.e. all will be triggered only on creation complete
			 * this was the same in the original vgExplorer
			 * maybe it was not intended */
			if(this.data is IVisualNode) {
				_rc.rotation = (this.data as IVisualNode).orientAngle;
			}
			
			this.addChild(_rc);
			
			/* now add the filters to the circle */
			reffects.addDSFilters(_rc);
			 
			/* now the link button */
			initLinkButton();
		}
	
		/**
		 * Event handler to turn the box if the orientation
		 * in a node changes *
		 * */
		public function updateNode(e:Event):void {
			
			var bounds:Array=new Array();
			
			if(_rc != null) {
				//LogUtil.info(_LOG, "updating rotation...");
				if(this.data is IVisualNode) {
					bounds = retrieveBounds(_rc.id);		
					initGraph(bounds[0],bounds[1]);
				}
			}
		}
		
		
		
		public function retrieveBounds(id:String):Array{
			return id.split('-');
		}	
		
		
		
		
	}
}
