EventDispatchController = {}

cc.GameObject.extend(EventDispatchController)
	:addComponent("components.behavior.EventProtocol"):exportMethods()

