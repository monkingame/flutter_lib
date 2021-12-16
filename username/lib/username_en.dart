import 'username.dart';

class ENUsername extends Username {
  ENUsername({String? surName, String? givenName})
      : super(surName: surName, givenName: givenName);

  String get fullname => getSurName() + getGivenName();

  // 姓氏
  List<String> get topSurNames {
    final names =
        'Smith, Jones, Taylor, Brown, Williams, Wilson, Johnson, Davies, Robinson, Wright, Thompson, Evans, Walker, White, Roberts, Green, Hall, Wood, Jackson, Clark, Patel, Thomas, Khan, Lewis, Clarke, James, Phillips, Ali, Mason, Mitchell, Rose, Davis, Rodríguez, Cox, Alexander, Campbell, Kelly, Johnston, Moore, Smyth, ONeill, Doherty, Stewart, Quinn, Murphy, Graham, Martin, McLaughlin, Hamilton, Murray, Hughes, Robertson, Thomson, Anderson, Scott, MacDonald, Reid, Ross, Young, Watson, Paterson, Morrison, Morgan, Griffiths, Edwards, Rees, Jenkins, Owen, Price, Moss, Driscoll, Miller, Garcia, Rodriguez, Martinez, Hernandez, Lopez, Lee, Gonzalez, Harris, Perez, Allen, Sanchez, King, Baker, Adams, Nelson, Hill, Ramirez, Carter, Turner, Torres, Parker, Collins, Flores, Morris, Nguyen, Rivera, Cook, Rogers, Peterson, Cooper, Reed, Bailey, Bell, Gomez, Howard, Ward, Diaz, Richardson, Brooks, Bennett, Gray, Reyes, Cruz, Myers, Long, Foster, Sanders, Morales, Powell, Sullivan, Russell, Ortiz, Gutierrez, Perry, Butler, Barnes, Fisher';

    // return names.split(',');
    return splitCommaString(names);
  }

  // 名称
  List<String> get topGivenNames {
    final names =
        'William, John, James, Jacob, Christopher, Joshua, Michael, Jackson, Jayden, Ethan, Tyler, Aiden, Joseph, Noah, Matthew, Anthony, Daniel, Angel, Alexander, Jose, Jesus, Landon, Hunter, David, Andrew, Gabriel, Elijah, Ryan, Nicholas, Samuel, Kevin, Isaiah, Logan, Carter, Gavin, Benjamin, Brayden, Christian, Caleb, Jack, Mason, Chase, Wyatt, Owen, Brody, Luis, Carlos, Diego, Sebastian, Juan, Adrian, Isaac, Evan, Emma, Madison, Addison, Ava, Emily, Chloe, Anna, Hannah, Isabella, Elizabeth, Abigail, Sophia, Olivia, Alyssa, Mia, Samantha, Brooklyn, Ashley, Natalie, Julia, Grace, Alexis, Brianna, Katherine, Lily, Hailey, Kayla, Lillian, Ella, Taylor, Makayla, Sarah, Nevaeh, Avery, Paola, Genesis, Gabriela, Nicole, Alondra, Nathan, Liam, Josiah, Ian, Yadiel, Allison, Charlotte, Zoe, Faith, Valeria, Kamila, Camila, Amanda, Andrea, Adriana, Alanis, Gabriella, Kaylee, Henry, Dylan, Bentley, Connor, Austin, Leah, Khloe, Aaliyah, Lucas, Easton, Parker, Amelia, Victoria, Sofia, Gianna, Aubrey, Maya, Mary, Harper, Evelyn, Lucy, Zoey, Robert, Micah, Jeremiah, Eli, Jaxon, Luke, Oliver, Cameron, Levi, Braxton, Jace, Layla, Riley, Naomi, Claire, Eleanor, Aria, Nora, Paisley, Lincoln, Ryker, Aubree, Serenity, Sadie, Charles, Ezekiel, Hudson, Colton, Brantley, Aurora, Alexandra, Lydia, Ariana, Ellie, Hadley, Ruby, Oakley, Julian, Ezra, Skylar, Caroline, Hazel, Scarlett, Savannah, Mila, Charlottte, Piper, Aspen, Grayson, Theodore, Kingston, Sawyer, Bridger, Cooper, Ximena';

    // return names.split(',');
    return splitCommaString(names);
  }
}
