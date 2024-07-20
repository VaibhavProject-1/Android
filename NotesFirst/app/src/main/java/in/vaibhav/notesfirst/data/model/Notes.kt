package `in`.vaibhav.notesfirst.data.model

data class Notes(
    val title: String,
    val description: String
)

data class NotesResponse(
    val id: Int,
    val title: String,
    val description: String,
    val created_at: String,
    val updated_at: String
)