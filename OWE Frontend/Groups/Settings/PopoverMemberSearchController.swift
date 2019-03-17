import UIKit

// MARK: - UISearch extension
extension PopoverMemberSearchController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}

protocol AddMemberDelegate: class {
  func addMembersToGroup(selectedMembers: [User])
}

class PopoverMemberSearchController: UIViewController, UITableViewDataSource, UITableViewDelegate, SelectMemberDelegate {
  
  // MARK: - Outlets
  @IBOutlet weak var userTable: UITableView!
  
  // MARK: - Properties
  let viewModelUser = GroupUsersViewModel()
  let searchController = UISearchController(searchResultsController: nil)
  var filteredUsers = [User]()
  var notInGroup = [User]()
  var selectedMembers = [User]()
  var viewModelMember = GroupUsersViewModel()
  var delegate: AddMemberDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSearchBar()
    
    let cellNib = UINib(nibName: "AddMemberTableCell", bundle: nil)
    userTable.register(cellNib, forCellReuseIdentifier: "addmember")
    userTable.tableFooterView = UIView()
    
    viewModelUser.refresh ({ [unowned self] in
      DispatchQueue.main.async {
        self.userTable.reloadData()
      }
      }, url: "https://oneworldexchange.herokuapp.com/users")

  }
  
  // get all the users in the system that aren't currenly in the group
  func newUsers(allUsers: [User], groupUsers: [User]) -> [User] {
    var newUsers = [User]()
    for user in allUsers {
      var count = 0
      for member in groupUsers {
        //if user === member
        if user.firstName == member.firstName {
          break
        } else {
          count += 1
        }
      }
      if count == groupUsers.count {
        newUsers.append(user)
        continue
      } else {
        continue
      }
    }
    return newUsers
  }
  
  // mark a newly selectedMember by moving to top and changing the cell color
  func selectMember(cell: AddMemberTableCell, didFinishAdding member: User, indexPath: Int) {
    selectedMembers.insert(member, at: 0)
    
    let sourceIndexPath = NSIndexPath(row: indexPath, section: 0) as IndexPath
    let destinationIndexPath = NSIndexPath(row: 0, section: 0) as IndexPath
    userTable.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    
    cell.backgroundColor = UIColor.yellow
  }
  
  // unselect a member by placing cell to its original location in the userTable
  func removeMember(cell: AddMemberTableCell, didFinishAdding member: User, indexPath: Int) {
    let index = selectedMembers.index(of: member)
    
    let currentIndexPath = NSIndexPath(row: index!, section: 0) as IndexPath
    let originalIndexPath = NSIndexPath(row: indexPath, section: 0) as IndexPath
    userTable.moveRow(at: currentIndexPath, to: originalIndexPath)
    
    selectedMembers.remove(at: index!)
    
    cell.backgroundColor = UIColor.white
  }
  
  // MARK: - Search User Table Views
  func beginSearch() -> Bool {
    notInGroup = newUsers(allUsers: viewModelUser.users, groupUsers: viewModelMember.users)
    return searchController.isActive
  }
  
  func isFiltering() -> Bool {
    return searchController.isActive && !searchBarIsEmpty()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering() {
      return filteredUsers.count
    } else if beginSearch() {
      return notInGroup.count
    } else {
      return notInGroup.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let user: User
    let cell = tableView.dequeueReusableCell(withIdentifier: "addmember", for: indexPath) as! AddMemberTableCell
    cell.delegate = self as SelectMemberDelegate
    cell.indexPath = indexPath.row
    if isFiltering() {
      user = filteredUsers[indexPath.row]
    } else {
      user = notInGroup[indexPath.row]
    }
    cell.member = user
    cell.nameLabel.text = user.name
    return cell
  }
  
  //MARK: - Search Methods
  func setupSearchBar() {
    searchController.searchResultsUpdater = self
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true
    searchController.searchBar.placeholder = "Add New Members"
    userTable.tableHeaderView = searchController.searchBar
  }
  
  func searchBarIsEmpty() -> Bool {
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  func filterContentForSearchText(_ searchText: String, scope: String = "All") {
    filteredUsers = notInGroup.filter { user in
      return user.name.lowercased().contains(searchText.lowercased())
    }
    
    userTable.reloadData()
  }
  
  @IBAction func addMembers() {
    delegate?.addMembersToGroup(selectedMembers: selectedMembers)
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func cancel() {
    dismiss(animated: true, completion: nil)
  }

}
