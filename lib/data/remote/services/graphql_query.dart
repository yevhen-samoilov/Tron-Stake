class GraphqlQuery {
  static String getBettingUser(String address) => """
query {  
  bettingUsers(filters:{user:{eq:"$address"}}, sort: "createdAt:desc", pagination:{pageSize:999999999}) {
    data{
      id
      attributes{
        user
        tokens
        tipsPurchased
        favorites
        sessionId
      }
    }
  }  
}
""";
  static String createBettingUser(String publicKey, int tokens) => """
mutation {
  createBettingUser(
    data:{
      user: "$publicKey",
      tokens: $tokens,
      tipsPurchased: []
    }
  ){
		data{
      id,
      attributes{
        user,
        tokens,
        tipsPurchased,
        sessionId
      }
    }
  }
}
""";

  static String bettingUser(String id) => """
query {  
  bettingUser(id:"$id") {
    data{
      id
      attributes{
        user
        tokens
        tipsPurchased
        favorites
        sessionId
      }
    }
  }  
}
""";
  static String livescore() => """
query {  
  livescore {
    data{
      attributes{
        data
      }
    }
  }  
}
""";

  static String over25() => """
query {  
  over25 {
    data{
      attributes{
        data
      }
    }
  }  
}
""";

  static String news() => """
query {  
  article {
    data{
      attributes{
        data
      }
    }
  }  
}
""";

  static String bettingPrompt() => """
query {  
  bettingPrompt {
    data{
      attributes{
        data
      }
    }
  }  
}
""";

  static String checkPromocode(String promocode) => """
query {  
  promocodes(filters:{promocode:{eq:"$promocode"}}, sort: "createdAt:desc", pagination:{pageSize:999999999}) {
    data { 
      id
      attributes { 
        users{
          data{
            id
          }
        }
        tokens
        promocode
      }  
    } 
  }  
}
""";

  static String updatePromocode(String promocodeID, String userID) => """
mutation {
  updatePromocode(id:"$promocodeID", data:{
    users:["$userID"]
  }){
		data{
      id
    }
  }
}
""";

  static String createBettingPay(
          String userID, String uuid, String bettingUser, int tokens) =>
      """
mutation {
  createBettingPay(
    data:{
      userID: "$userID",
      uuid: "$uuid",
      betting_user: "$bettingUser",
      tokens: $tokens,
    }
  ){
		data{
      id
    }
  }
}
""";

  static String getPay(String payId) => """
query {  
bettingPay(id:"$payId") {
	data{
    id
		attributes{
      userID
      betting_user{
        data{
          attributes{
					tokens
          }
        }
      }
			uuid
      tokens
      pay
			}
		}
	}  
}
""";

  static String updateBalance(String id, num tokens) => """
mutation {
  updateBettingUser(
    id: "$id",
    data:{
      tokens: $tokens,
    }
  ){
		data{
      id,
      attributes{
        user,
        tokens,
        sessionId
      }
    }
  }
}
""";

  static String updateListUser(String id, num tokens, List<dynamic> list) => """
mutation {
  updateBettingUser(
    id: "$id",
    data:{
      tokens: $tokens,
      tipsPurchased: ${list.toString()},
    }
  ){
		data{
      id,
      attributes{
        user,
        tokens,
        sessionId
      }
    }
  }
}
""";

  static String updateFavorites(String id, List<dynamic> list) => """
mutation {
  updateBettingUser(
    id: "$id",
    data:{
      favorites: ${list.toString()},
    }
  ){
		data{
      id,
      attributes{
        user,
        tokens,
        sessionId
      }
    }
  }
}
""";

  static String updateSessionId(String id, String sessionId) => """
mutation {
  updateBettingUser(
    id: "$id",
    data:{
      sessionId: "$sessionId",
    }
  ){
		data{
      id,
      attributes{
        user,
        tokens,
        sessionId
      }
    }
  }
}
""";

  static String updateBettingPay(String id, String datetimepay) => """
mutation {
  updateBettingPay(
    id:"$id",
    data:{
      datetimepay:"$datetimepay",
      pay:true,
    }
  ){
		data{
      id,
    }
  }
}
""";

//
//
//

  static String me() => """
query {
  me {
    id
    username
    email
    balanceTokens
  }
}
""";

  static String createAiChat(String userID) => """
mutation {
  createAiChat(data:{
    user: "$userID",
    participants: ["$userID"]
  }){
    data{
      id
    }
  }
}
""";

  static String createMessage(String userID, String chatID, String text) {
    text = text
        .replaceAll('\\', '\\\\')
        .replaceAll('"', '\\"')
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r')
        .replaceAll('\t', '\\t');
    return """
    mutation {
      createMessage(
        data: {
          text: "$text",
          chat: "$chatID",
          user: "$userID",
        }){
        data{
          attributes{
            text
          }
        }
      }
    }
    """;
  }

  static String getChatsCopy(int userID) => """
query {  
  aiChats(filters:{user:{id:{eq:$userID}}}, sort: "createdAt:desc", pagination:{pageSize:999999999}) {
    data { 
      id
      attributes { 
        createdAt
        messages(sort: "createdAt:desc", pagination:{pageSize:1}){
          data{
            attributes{
            text
          }}
        }
      }  
    }  
    meta {  
      pagination {  
        page  
        pageSize  
        total  
        pageCount
      }
    }  
  }  
}
""";

  static String getChat(String chatID) => """
query {  
  aiChat(id:"$chatID") {
    data { 
      id
      attributes { 
        user{
          data{
            attributes{
              username
            }
          }
        }
        createdAt
        participants{
          data{
            attributes{
            username
          }}
        }
        pinned
        messages(pagination:{pageSize:999999999}){
          data{
            id
            attributes{
            text
            user{
          		data{
                id
          		}
        		}
          }}
        }
      }  
    }  
  }  
}
""";

  static String getChats(String userID) => """
query {  
  aiChats(filters:{user:{id:{eq:$userID}}}, sort: "createdAt:desc", pagination:{pageSize:999999999}) {
    data { 
      id
      attributes { 
        user{
          data{
            attributes{
              username
            }
          }
        }
        createdAt
        participants{
          data{
            attributes{
            username
          }}
        }
        messages(pagination:{pageSize:999999999}){
          data{
            id
            attributes{
            text
          }}
        }
      }  
    }  
    meta {  
      pagination {  
        page  
        pageSize  
        total  
        pageCount
      }
    }  
  }  
}
""";

  static String deleteChat(String chatID) => """
mutation {
  deleteAiChat(id:"$chatID"){
		data{
      id
    }
  }
}
""";

  static String deleteMessage(String messageID) => """
mutation {
  deleteMessage(id: "$messageID"){
		data{
      id
    }
  }
}
""";
  static String updateMessage(String messageID, String chatID) => """
mutation {
  updateMessage(
    id:"$messageID",
    data: {
      aiChatPin:"$chatID",
    }){
		data{
      id
    }
  }
}
""";
  static String updateAiChat(String chatID, List<int> listPinned) => """
mutation {
  updateAiChat(
    id:"$chatID",
    data: {
      pinned: $listPinned
    }){
		data{
      id
    }
  }
}
""";
}
