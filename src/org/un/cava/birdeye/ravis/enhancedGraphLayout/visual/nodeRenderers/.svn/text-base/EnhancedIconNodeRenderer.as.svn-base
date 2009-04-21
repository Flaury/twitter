package org.un.cava.birdeye.ravis.enhancedGraphLayout.visual.nodeRenderers
{
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.core.Container;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.UIDUtil;
	
	import org.un.cava.birdeye.ravis.components.renderers.RendererIconFactory;
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.visual.EnhancedVisualGraph;
	import org.un.cava.birdeye.ravis.enhancedGraphLayout.visual.INodeRenderer;
	import org.un.cava.birdeye.ravis.graphLayout.layout.HierarchicalLayouter;
	import org.un.cava.birdeye.ravis.graphLayout.layout.ILayoutAlgorithm;
	import org.un.cava.birdeye.ravis.graphLayout.visual.IVisualNode;

	public class EnhancedIconNodeRenderer extends Container implements INodeRenderer
	{
		private var size:Number = 32;
		public function EnhancedIconNodeRenderer()
		{
			super();
			this.width = this.height = size;
			this.addEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
		}
		/**
		 * @inheritDoc
		 * */
		protected function initComponent(e:Event):void {
			
			this.removeEventListener(FlexEvent.CREATION_COMPLETE, initComponent);
			var img:UIComponent;
			
			/* add an icon as specified in the XML, this should
			 * be checked */
			if (this.data.data is XML)
			{
				img = RendererIconFactory.createIcon(this.data.data.@nodeIcon,size);
				img.toolTip = this.data.data.@name; // needs check
			}
			else
			{
				img = RendererIconFactory.createIcon(this.data.data.nodeIcon,size - 2*this.getStyle("borderThickness"));
				img.toolTip = this.data.data.name; // needs check
			}
			this.addChild(img);
			this.contextMenu = createContextMenu();
		}
		
		protected function createContextMenu():ContextMenu 
		{
			var contextMenu:ContextMenu = new ContextMenu();
			contextMenu.hideBuiltInItems();
			
			var newChild:ContextMenuItem = new ContextMenuItem("New Child");
			newChild.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, newChildItemClick);
			contextMenu.customItems.push(newChild);
			
			var delNode:ContextMenuItem = new ContextMenuItem("Delete Node");
			delNode.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deleteNodeItemClick);
			contextMenu.customItems.push(delNode);
			
			var delNodeAndRebindChild:ContextMenuItem = new ContextMenuItem("Delete Node and Rebind Child");
			delNodeAndRebindChild.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, deleteNodeAndRebindChildItemClick);
			contextMenu.customItems.push(delNodeAndRebindChild);
			
			return contextMenu;	
		}
		
		private function newChildItemClick(event:ContextMenuEvent):void
		{
			var childData:Object = ObjectUtil.copy(IVisualNode(this.data).data);
			childData.id = UIDUtil.createUID();
			childData.description = 'This is new node';
			EnhancedVisualGraph(IVisualNode(this.data).vgraph).addVNodeAsChild(childData.id, childData, IVisualNode(this.data).node);
		}
		
		private function deleteNodeItemClick(event:ContextMenuEvent):void
		{
			EnhancedVisualGraph(IVisualNode(this.data).vgraph).removeNodeWithOption(IVisualNode(this.data).node, false);
		}
		
		private function deleteNodeAndRebindChildItemClick(event:ContextMenuEvent):void
		{
			EnhancedVisualGraph(IVisualNode(this.data).vgraph).removeNodeWithOption(IVisualNode(this.data).node, true);
		}	
		public function labelCoordinates(label:UIComponent):Point
		{
			if (this.data is IVisualNode)
			{
				var hInside:Boolean = true;
				var vInside:Boolean = false;
				var hAlign:String = "center"; //left, right, center
				var vAlign:String = "bottom"; //top, bottom, middle
			
	
				var labelx:Number;
				var labely:Number;
				var currentLayouter:ILayoutAlgorithm = IVisualNode(this.data).vgraph.layouter;
				
				if (currentLayouter is HierarchicalLayouter)
				{
					switch ((currentLayouter as HierarchicalLayouter).orientation)
					{
						case HierarchicalLayouter.ORIENT_BOTTOM_UP:
						{
							hInside = true;
							vInside = false;
							hAlign = "center";
							vAlign = "top";
							break;
						}
						
						case HierarchicalLayouter.ORIENT_TOP_DOWN:
						{
							hInside = true;
							vInside = false;
							hAlign = "center";
							vAlign = "bottom";
							break;
						}
						
						case HierarchicalLayouter.ORIENT_LEFT_RIGHT:
						{
							hInside = false;
							vInside = true;
							hAlign = "right";
							vAlign = "middle";
							break;
						}
						
						case HierarchicalLayouter.ORIENT_RIGHT_LEFT:
						{
							hInside = false;
							vInside = true;
							hAlign = "left";
							vAlign = "middle";
							break;
						}
					}
				}
				switch (hAlign)
				{
					case "left":
					{
						labelx = IVisualNode(this.data).view.x;
						if (hInside == false) labelx -= label.width;
						break;
					}
					case "right":
					{
						labelx = IVisualNode(this.data).view.x + IVisualNode(this.data).view.width;
						if (hInside == true) labelx -= label.width;
						break;
					}
					case "center":
					{
						labelx = IVisualNode(this.data).view.x + IVisualNode(this.data).view.width/2 - label.width/2;
						break;
					}
					default:
						labelx = IVisualNode(this.data).viewCenter.x;
				}
						
				switch (vAlign)
				{
					case "top":
					{
						labely = IVisualNode(this.data).view.y;
						if (vInside == false) labely -= label.height;
						break;
					}
					case "bottom":
					{
						labely = IVisualNode(this.data).view.y + IVisualNode(this.data).view.height;
						if (vInside == true) labely -= label.height;
						break;
					}
					case "middle":
					{
						labely = IVisualNode(this.data).view.y + IVisualNode(this.data).view.height/2 - label.height/2;
						break;
					}
					default:
						labely = IVisualNode(this.data).viewCenter.y;
				}
				return new Point(labelx, labely);
			}
			else 
				return new Point(this.x + this.width/2, this.y + this.height/2)
					
		}
	}
}