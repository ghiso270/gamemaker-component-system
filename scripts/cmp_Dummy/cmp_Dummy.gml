/// @desc Component that does nothing. Can be used for testing or as a placeholder
/// @arg {String}			name				name of the component
/// @arg {Array<String>}	tags				tags of the component ("*" is reserved, so it must not be included)

function cmp_Dummy(name, tags) : Component(name, array_push_and_return(tags, "::cmp_Dummy"), []) constructor{}