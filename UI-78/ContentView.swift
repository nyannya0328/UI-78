//
//  ContentView.swift
//  UI-78
//
//  Created by にゃんにゃん丸 on 2020/12/19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    var width = UIScreen.main.bounds.width - (40 + 60)
    var height = UIScreen.main.bounds.height / 2
    
    @State var books = [
        
        Book(id: 0, image: "p1", offset: 0),
        Book(id: 1, image: "p2", offset: 0),
        Book(id: 2, image: "p3", offset: 0),
        Book(id: 3, image: "p4", offset: 0),
        Book(id: 4, image: "p5", offset: 0),
        Book(id: 5, image: "p6", offset: 0),
        Book(id: 6, image: "p7", offset: 0),
        
    ]
    @State var swiPed = 0
    
    var body: some View{
        
        VStack{
            
            HStack{
                
                
                Text("Carousel")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Spacer(minLength: 0)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName:"circle.grid.3x3.fill")
                        .font(.system(size: 25))
                        .foregroundColor(.white)
                })
            }
            .padding(.horizontal)
            
            Spacer(minLength: 0)
            
            ZStack{
                
                ForEach(books.reversed()){book in
                    
                    
                    HStack{
                        
                        ZStack{
                            
                            Image(book.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: width, height: getHeight(index: book.id))
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
                            
                            CardView(card: book)
                                .frame(width: width, height: getHeight(index: book.id))
                        }
                        
                        
                    }
                    
                    
                    .contentShape(Rectangle())
                    .padding(.horizontal)
                    .offset(x: book.id - swiPed < 3 ? CGFloat(book.id - swiPed) * 40 : 80)
                    .offset(x: book.offset)
                    .gesture(DragGesture().onChanged({ (value) in
                        withAnimation{onScroll(value: value.translation.width, index: book.id)}
                    }).onEnded({ (value) in
                        withAnimation{onEnd(value: value.translation.width, index: book.id)}
                    }))
                    
                    
                    
                    
                    
                    
                }
                
                
            }
            .frame(height: height)
            PageController(total: books.count, current: $swiPed)
            
            Spacer(minLength: 0)
        }
        .background(Color("bg").ignoresSafeArea(.all, edges: .all))
        
        
    }
    
    func getHeight(index : Int) -> CGFloat{
        
        return height - (index - swiPed < 3 ? CGFloat(index - swiPed) * 40 : 80)
        
        
        
    }
    
    func onScroll(value : CGFloat,index : Int){
        
        if value < 0{
            if index != books.last!.id{
                
                
                books[index].offset = value
            }
            
        }
        else{
            if index > 0{
                
                if books[index - 1].offset <= 20{
                    
                    books[index - 1].offset = -(width+40) + value
                    
                }
                
                
            }
        }
        
    }
    func onEnd(value : CGFloat,index : Int){
        
        if value < 0{
            if -value > width / 2 && index != books.last!.id{
                
                books[index].offset = -(width + 60)
                swiPed += 1
            }
            else{
                
                books[index].offset = 0
            }
        }
        else{
            
            
            if index > 0{
                
                if value > width / 2{
                    
                    books[index - 1].offset = 0
                    swiPed -= 1
                    
                }
                else{
                    
                    books[index - 1].offset = -(width + 100)
                    
                }
            }
        }
        
        
        
    }
    
}

struct PageController : UIViewRepresentable{
    var total : Int
    @Binding var current : Int
    func makeUIView(context: Context) -> UIPageControl {
        
        let view = UIPageControl()
        view.numberOfPages = total
        view.currentPage = current
        view.preferredIndicatorImage = UIImage(systemName: "book.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30))
        
        view.backgroundStyle = .prominent
        
        
        
        
        
        return view
        
    }
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        
        uiView.currentPage = current
        
    }
}

struct CardView : View {
    var card : Book
    
    var body: some View{
        
        VStack{
            
            Spacer(minLength: 0)
            HStack{
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Now")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.vertical,5)
                        .padding(.horizontal,10)
                        .background(Color.blue)
                        .clipShape(Capsule())
                        .padding(.bottom,5)
                    
                    Spacer(minLength: 0)
                    
                    
                })
                
                
                
            }
            .padding()
            
        }
        
    }
}

struct Book : Identifiable {
    var id :Int
    var image : String
    var offset : CGFloat
    
}

