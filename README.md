# roar-json_form

Representers for the (unofficial!) Form+JSON media type.

## Installation

    gem 'roar-json_form'


## Example for Form+JSON

		[
			{ 
				type  : "text",
				name  : "text", 
				label : "Comment (160 max.)"
			},

			{
				type  : "radio",
				name  : "rating", 
				label : "Was this gem helpful to you?",
				data  :[
					{ value: 1, src: "thumb_up.png", label: "Hell yeah!" },
					{ value: 0, src: "thumb_down.png", label: "Not really..."}
				]
			},

			{
				type  : "select",
				name  : "version",
				size  : 1, 
				data  : [
					{ value: current, selected: true, text: current },
					{ value: v0.0.9 }
				]
			}
		]

		+ validations!
