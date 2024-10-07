import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.vaibhav.usermanagement.data.User
import com.vaibhav.usermanagement.data.UserDao
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class UserViewModel(private val userDao: UserDao) : ViewModel() {
    // Users flow to collect users
    private val _users = MutableStateFlow<List<User>>(emptyList())
    val users: StateFlow<List<User>> = _users.asStateFlow()

    // Selected user flow
    private val _selectedUser = MutableStateFlow<User?>(null)
    val selectedUser: StateFlow<User?> = _selectedUser.asStateFlow()

    init {
        loadUsers()  // Load users when ViewModel is initialized
    }

    fun addUser(user: User) {
        // Launch a coroutine to insert the user in the database
        viewModelScope.launch {
            userDao.insertUser(user)
            loadUsers() // Refresh the list after insertion
        }
    }

    private fun loadUsers() {
        // Launch a coroutine to get all users as a Flow from the database
        viewModelScope.launch {
            userDao.getAllUsersFlow().collect { userList ->
                _users.value = userList
            }
        }
    }

    // Add the showEditDialog state to ViewModel
    var showEditDialog by mutableStateOf(false)

    fun updateUser(user: User) {
        viewModelScope.launch {
            userDao.updateUser(user)
            loadUsers() // Reload users after updating
        }
    }

    fun deleteUser(user: User) {
        viewModelScope.launch {
            userDao.deleteUser(user)
            loadUsers()  // Refresh the list after deleting
        }
    }

    fun selectUser(user: User) {
        _selectedUser.value = user
    }
}
