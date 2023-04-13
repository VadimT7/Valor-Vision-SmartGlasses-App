// Generated using the ObjectBox Swift Generator — https://objectbox.io
// DO NOT EDIT

// swiftlint:disable all
import ObjectBox
import Foundation

// MARK: - Entity metadata


extension User: ObjectBox.__EntityRelatable {
    internal typealias EntityType = User

    internal var _id: EntityId<User> {
        return EntityId<User>(self.id.value)
    }
}

extension User: ObjectBox.EntityInspectable {
    internal typealias EntityBindingType = UserBinding

    /// Generated metadata used by ObjectBox to persist the entity.
    internal static var entityInfo = ObjectBox.EntityInfo(name: "User", id: 1)

    internal static var entityBinding = EntityBindingType()

    fileprivate static func buildEntity(modelBuilder: ObjectBox.ModelBuilder) throws {
        let entityBuilder = try modelBuilder.entityBuilder(for: User.self, id: 1, uid: 4687130525637896704)
        try entityBuilder.addProperty(name: "id", type: PropertyType.long, flags: [.id], id: 1, uid: 8106370884158779392)
        try entityBuilder.addProperty(name: "firstName", type: PropertyType.string, id: 3, uid: 4054984470590511360)
        try entityBuilder.addProperty(name: "lastName", type: PropertyType.string, id: 4, uid: 8293440642595545088)
        try entityBuilder.addProperty(name: "password", type: PropertyType.string, id: 5, uid: 45610949015348224)
        try entityBuilder.addProperty(name: "policeID", type: PropertyType.long, id: 6, uid: 7469659137062754048)
        try entityBuilder.addProperty(name: "locX", type: PropertyType.float, id: 7, uid: 2669677264091848448)
        try entityBuilder.addProperty(name: "locY", type: PropertyType.float, id: 8, uid: 7940162628339250432)

        try entityBuilder.lastProperty(id: 10, uid: 9072959716666314752)
    }
}

extension User {
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { User.id == myId }
    internal static var id: Property<User, Id, Id> { return Property<User, Id, Id>(propertyId: 1, isPrimaryKey: true) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { User.firstName.startsWith("X") }
    internal static var firstName: Property<User, String, Void> { return Property<User, String, Void>(propertyId: 3, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { User.lastName.startsWith("X") }
    internal static var lastName: Property<User, String, Void> { return Property<User, String, Void>(propertyId: 4, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { User.password.startsWith("X") }
    internal static var password: Property<User, String, Void> { return Property<User, String, Void>(propertyId: 5, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { User.policeID > 1234 }
    internal static var policeID: Property<User, Int, Void> { return Property<User, Int, Void>(propertyId: 6, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { User.locX > 1234 }
    internal static var locX: Property<User, Float, Void> { return Property<User, Float, Void>(propertyId: 7, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { User.locY > 1234 }
    internal static var locY: Property<User, Float, Void> { return Property<User, Float, Void>(propertyId: 8, isPrimaryKey: false) }

    fileprivate func __setId(identifier: ObjectBox.Id) {
        self.id = Id(identifier)
    }
}

extension ObjectBox.Property where E == User {
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .id == myId }

    internal static var id: Property<User, Id, Id> { return Property<User, Id, Id>(propertyId: 1, isPrimaryKey: true) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .firstName.startsWith("X") }

    internal static var firstName: Property<User, String, Void> { return Property<User, String, Void>(propertyId: 3, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .lastName.startsWith("X") }

    internal static var lastName: Property<User, String, Void> { return Property<User, String, Void>(propertyId: 4, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .password.startsWith("X") }

    internal static var password: Property<User, String, Void> { return Property<User, String, Void>(propertyId: 5, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .policeID > 1234 }

    internal static var policeID: Property<User, Int, Void> { return Property<User, Int, Void>(propertyId: 6, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .locX > 1234 }

    internal static var locX: Property<User, Float, Void> { return Property<User, Float, Void>(propertyId: 7, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .locY > 1234 }

    internal static var locY: Property<User, Float, Void> { return Property<User, Float, Void>(propertyId: 8, isPrimaryKey: false) }

}


/// Generated service type to handle persisting and reading entity data. Exposed through `User.EntityBindingType`.
internal class UserBinding: ObjectBox.EntityBinding {
    internal typealias EntityType = User
    internal typealias IdType = Id

    internal required init() {}

    internal func generatorBindingVersion() -> Int { 1 }

    internal func setEntityIdUnlessStruct(of entity: EntityType, to entityId: ObjectBox.Id) {
        entity.__setId(identifier: entityId)
    }

    internal func entityId(of entity: EntityType) -> ObjectBox.Id {
        return entity.id.value
    }

    internal func collect(fromEntity entity: EntityType, id: ObjectBox.Id,
                                  propertyCollector: ObjectBox.FlatBufferBuilder, store: ObjectBox.Store) throws {
        let propertyOffset_firstName = propertyCollector.prepare(string: entity.firstName)
        let propertyOffset_lastName = propertyCollector.prepare(string: entity.lastName)
        let propertyOffset_password = propertyCollector.prepare(string: entity.password)

        propertyCollector.collect(id, at: 2 + 2 * 1)
        propertyCollector.collect(entity.policeID, at: 2 + 2 * 6)
        propertyCollector.collect(entity.locX, at: 2 + 2 * 7)
        propertyCollector.collect(entity.locY, at: 2 + 2 * 8)
        propertyCollector.collect(dataOffset: propertyOffset_firstName, at: 2 + 2 * 3)
        propertyCollector.collect(dataOffset: propertyOffset_lastName, at: 2 + 2 * 4)
        propertyCollector.collect(dataOffset: propertyOffset_password, at: 2 + 2 * 5)
    }

    internal func createEntity(entityReader: ObjectBox.FlatBufferReader, store: ObjectBox.Store) -> EntityType {
        let entity = User()

        entity.id = entityReader.read(at: 2 + 2 * 1)
        entity.firstName = entityReader.read(at: 2 + 2 * 3)
        entity.lastName = entityReader.read(at: 2 + 2 * 4)
        entity.password = entityReader.read(at: 2 + 2 * 5)
        entity.policeID = entityReader.read(at: 2 + 2 * 6)
        entity.locX = entityReader.read(at: 2 + 2 * 7)
        entity.locY = entityReader.read(at: 2 + 2 * 8)

        return entity
    }
}


/// Helper function that allows calling Enum(rawValue: value) with a nil value, which will return nil.
fileprivate func optConstruct<T: RawRepresentable>(_ type: T.Type, rawValue: T.RawValue?) -> T? {
    guard let rawValue = rawValue else { return nil }
    return T(rawValue: rawValue)
}

// MARK: - Store setup

fileprivate func cModel() throws -> OpaquePointer {
    let modelBuilder = try ObjectBox.ModelBuilder()
    try User.buildEntity(modelBuilder: modelBuilder)
    modelBuilder.lastEntity(id: 1, uid: 4687130525637896704)
    return modelBuilder.finish()
}

extension ObjectBox.Store {
    /// A store with a fully configured model. Created by the code generator with your model's metadata in place.
    ///
    /// - Parameters:
    ///   - directoryPath: The directory path in which ObjectBox places its database files for this store.
    ///   - maxDbSizeInKByte: Limit of on-disk space for the database files. Default is `1024 * 1024` (1 GiB).
    ///   - fileMode: UNIX-style bit mask used for the database files; default is `0o644`.
    ///     Note: directories become searchable if the "read" or "write" permission is set (e.g. 0640 becomes 0750).
    ///   - maxReaders: The maximum number of readers.
    ///     "Readers" are a finite resource for which we need to define a maximum number upfront.
    ///     The default value is enough for most apps and usually you can ignore it completely.
    ///     However, if you get the maxReadersExceeded error, you should verify your
    ///     threading. For each thread, ObjectBox uses multiple readers. Their number (per thread) depends
    ///     on number of types, relations, and usage patterns. Thus, if you are working with many threads
    ///     (e.g. in a server-like scenario), it can make sense to increase the maximum number of readers.
    ///     Note: The internal default is currently around 120.
    ///           So when hitting this limit, try values around 200-500.
    /// - important: This initializer is created by the code generator. If you only see the internal `init(model:...)`
    ///              initializer, trigger code generation by building your project.
    internal convenience init(directoryPath: String, maxDbSizeInKByte: UInt64 = 1024 * 1024,
                            fileMode: UInt32 = 0o644, maxReaders: UInt32 = 0, readOnly: Bool = false) throws {
        try self.init(
            model: try cModel(),
            directory: directoryPath,
            maxDbSizeInKByte: maxDbSizeInKByte,
            fileMode: fileMode,
            maxReaders: maxReaders,
            readOnly: readOnly)
    }
}

// swiftlint:enable all
